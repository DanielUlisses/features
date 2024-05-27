
# Common Tools

This feature only adds a few components on top of the base devcontainer image
- fzf (fuzzy finder)
- gzip (compression tool)
- antibody (zsh plugin manager)

## Example Usage

```json
"features": {
    "ghcr.io/danielulisses/features/common-tools:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| install_antibody | Install antibody | boolean | true |
| install_fzf | Install fzf | boolean | true |


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/devcontainers/feature-starter/blob/main/src/hello/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
