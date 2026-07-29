# RelayKey Homebrew tap

Administer machines behind firewalls over end-to-end encryption, with no backend
server. [Main project and downloads](https://github.com/ptrinh/relaykey-public).

```sh
brew tap ptrinh/relaykey
```

## The client — the app you drive machines *from* (macOS, Apple Silicon)

```sh
brew install --cask --no-quarantine relaykey-client
```

`--no-quarantine` is needed because the build is Developer ID signed but not yet
notarised; without it Gatekeeper blocks the first launch. Prefer not to pass it?
Install normally, then `xattr -dr com.apple.quarantine /Applications/RelayKey.app`.

There is also a browser client that needs no install: <https://relaykey.pages.dev>

## The agent — runs *on* each machine you want to control (macOS + Linux)

```sh
brew install relaykey-agent
sudo relaykey install -paircode=CODE
```

Get `CODE` from the client's "Add machine", then compare the six-digit number on
both sides before accepting. The agent registers its own launchd/systemd service
so it runs for the machine rather than for your login session — `brew services`
is deliberately not used. Check it with `relaykey status`.

No Homebrew on that box?

```sh
curl -fsSL https://github.com/ptrinh/relaykey-public/releases/latest/download/install.sh | sh
```

The installer picks the right OS/arch build, verifies it against the release's
`SHA256SUMS`, and refuses to install if the manifest is missing or the checksum
does not match.

## Uninstalling

```sh
sudo relaykey uninstall        # deregister the agent service (-purge to erase its state)
brew uninstall relaykey-agent
brew uninstall relaykey-client # keeps your identity; --zap erases it and unpairs everything
```
