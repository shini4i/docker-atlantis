# atlantis
A custom atlantis docker image with built-in transcrypt.
## Usage example
Custom workflow example
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
