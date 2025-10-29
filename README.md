# klinke.studio Code Theme

This is a VSCode theme using the same defined color scheme as I use on [my website](https://klinke.studio).

## Local development

- `make format` runs Prettier across the repository.
- `make build` packages the extension into `dist/klinke-studio-theme-<version>.vsix` using `vsce` (runs `make format` first).
- `make install` rebuilds the extension and copies it into your local VS Code extensions folder for quick testing.

## Continuous delivery

Every push to `main` automatically builds the VSIX package on GitHub Actions and publishes a prerelease containing the downloadable artifact.
