# The RelayKey client: the desktop app you drive other machines FROM.
# Apple Silicon only — the release ships a single-arch app.
cask "relaykey-client" do
  version "0.4.0"
  sha256 "b13d0b0570139909639c5a718d7e651de0d4f8ace17f3fcfc5b5e57ddb4dddc0"

  url "https://github.com/ptrinh/relaykey-public/releases/download/v#{version}/relaykey-client-gui-macos-arm64.zip",
      verified: "github.com/ptrinh/relaykey-public/"
  name "RelayKey"
  desc "Administer machines behind firewalls over end-to-end encryption, with no backend server"
  homepage "https://github.com/ptrinh/relaykey-public"

  depends_on arch: :arm64
  depends_on macos: ">= :sonoma"

  app "RelayKey.app"

  uninstall quit: "com.relaykey.client"

  # Identity lives in the login keychain; peers.json and settings in Application
  # Support. Removed only on `brew uninstall --zap`, never on a plain uninstall —
  # losing the identity means re-pairing every machine from its console.
  zap trash: [
    "~/Library/Application Support/RelayKey",
    "~/Library/Preferences/com.relaykey.client.plist",
    "~/Library/Saved Application State/com.relaykey.client.savedState",
  ]

  caveats <<~EOS
    This build is signed with a Developer ID but is not yet notarised, so
    Gatekeeper will refuse the first launch. Either install with

      brew install --cask --no-quarantine relaykey-client

    or, after a normal install, allow it once:

      xattr -dr com.apple.quarantine "/Applications/RelayKey.app"

    Your identity is stored in the login keychain. `brew uninstall` keeps it;
    use `brew uninstall --zap` to erase it, which unpairs every machine.
  EOS
end
