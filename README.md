# atlantis
A custom atlantis docker image with built-in [transcrypt](https://github.com/elasticdog/transcrypt), [terragrunt](https://github.com/gruntwork-io/terragrunt) and [terragrunt-atlantis-config](https://github.com/transcend-io/terragrunt-atlantis-config).
## Usage example
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
## Configuration
Atlantis server config example utilizing terragrunt + terragrunt-atlantis-config:
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
