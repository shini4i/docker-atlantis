# atlantis
A custom atlantis docker image with built-in [transcrypt](https://github.com/elasticdog/transcrypt), [terragrunt](https://github.com/gruntwork-io/terragrunt) and [terragrunt-atlantis-config](https://github.com/transcend-io/terragrunt-atlantis-config).
## Usage example
Custom workflow example utilizing transcrypt
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
