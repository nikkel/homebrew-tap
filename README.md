# homebrew-tap

[Homebrew](https://brew.sh) tap for [gitaway](https://github.com/nikkel/gitaway), which reaches your self-hosted git server from anywhere.

```sh
brew install nikkel/tap/gitaway
```

This installs the prebuilt release binary for macOS (Apple Silicon and Intel) or Linux (arm64 and x86_64), the `git-away` command (so `git away` works), and the man pages. Upgrade with `brew upgrade gitaway`.

## Is it the real release?

Each release file has a GitHub artifact attestation. The formula's SHA-256 values are computed from archives that passed `gh attestation verify` against gitaway's release tag, so a hash here can only come from a build made by gitaway's own release workflow. Homebrew checks the hash again on every install.

The macOS binaries aren't signed or notarized by Apple yet. Homebrew downloads don't carry the quarantine flag, so they run without a Gatekeeper prompt.

## How it's kept up to date

`.github/workflows/update.yml` runs every day. If gitaway has a new full release (pre-releases are ignored), it runs `scripts/update-formula.py`, commits the new version and hashes, and starts the `Test` workflow, which audits, installs and tests the formula on Linux and macOS. To update by hand, run the workflow from the Actions tab, or `scripts/update-formula.py [VERSION]` with `gh` logged in. No secrets are involved.

## Licence

MIT, as in [LICENSE](LICENSE).
