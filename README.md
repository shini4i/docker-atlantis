<div align="center">

# atlantis
A custom [atlantis](https://github.com/runatlantis/atlantis) docker image with built-in [infracost](https://github.com/infracost/infracost), [transcrypt](https://github.com/elasticdog/transcrypt), [terragrunt](https://github.com/gruntwork-io/terragrunt), [terragrunt-atlantis-config](https://github.com/transcend-io/terragrunt-atlantis-config) and [atlantis-emoji-gate](https://github.com/shini4i/atlantis-emoji-gate)

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/shini4i/docker-atlantis/build-and-publish.yml?branch=main&style=flat-square)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/shini4i/docker-atlantis/main?style=flat-square)
![GitHub tag (latest by date)](https://img.shields.io/github/v/tag/shini4i/docker-atlantis?style=flat-square)

<img src="https://raw.githubusercontent.com/runatlantis/atlantis/main/runatlantis.io/public/hero.png" alt="Showcase">
</div>

## Download latest built image
```bash
docker pull ghcr.io/shini4i/atlantis:v0.30.0
```

## Configuration example
### Transcrypt
Custom workflow example utilizing transcrypt:
```yaml
workflows:
  terraform-transcrypt:
    plan:
      steps:
        - run: transcrypt -c aes-256-cbc -p "$TRANSCRYPT_PASSWORD" --yes || transcrypt -c aes-256-cbc -p "$TRANSCRYPT_PASSWORD" --upgrade --yes
        - init
        - plan
    apply:
      steps:
        - apply
```
### Terragrunt
Atlantis server configuration example utilizing terragrunt + terragrunt-atlantis-config:
```yaml
repoConfig: |
  ---
  repos:
    - id: /.*/
      apply_requirements: [mergeable, approved]
      workflow: default
      allowed_overrides: []
      allow_custom_workflows: false
      pre_workflow_hooks:
        - run: terragrunt-atlantis-config generate --output atlantis.yaml --autoplan
  workflows:
    default:
      plan:
        steps: 
          # additional init step is required if you need to provide credentials for backend config
          - run: terragrunt init -backend-config="username=$ATLANTIS_USER" -backend-config="password=$ATLANTIS_TOKEN"
          - run: terragrunt plan -input=false -out=$PLANFILE
          - run: terragrunt show -json $PLANFILE > $SHOWFILE
      apply:
        steps:
          - run: terragrunt apply -input=false $PLANFILE
```

### Atlantis-Emoji-Gate

This setup is useful only for setups running with Gitlab CE. It replaces non-working mandatory approvals with custom emoji-based approvals:

More info can be found [here](https://github.com/shini4i/atlantis-emoji-gate).

```yaml
workflows:
  default:
    plan:
      steps:
        - init
        - plan
    apply:
      steps:
        - run: atlantis-emoji-gate
        - apply
```
