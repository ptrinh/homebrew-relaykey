# The RelayKey client: the desktop app you drive other machines FROM.
# Apple Silicon only — the release ships a single-arch app.
cask "relaykey-client" do
  version "0.4.0"
  sha256 "9c25311f5ace5f40d64d65af4103d2b293d15459379852787cbbbcbda2de3eaa"

  url "https://github.com/ptrinh/relaykey-public/releases/download/v#{version}/relaykey-client-gui-macos-arm64.zip",
      verified: "github.com/ptrinh/relaykey-public/"
  name "RelayKey"
  desc "Administer machines behind firewalls over end-to-end encryption, with no backend server"
  homepage "https://github.com/ptrinh/relaykey-public"

  depends_on arch: :arm64
  depends_on macos: :sonoma

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
    Your identity is stored in the login keychain, so `brew uninstall` keeps it
    and reinstalling does not require re-pairing. `brew uninstall --zap` erases
    it, which unpairs every machine and cannot be undone from this Mac.
  EOS
end
