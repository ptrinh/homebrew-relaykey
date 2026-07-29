# The RelayKey agent: runs ON a machine you want to administer remotely.
# Ships as a prebuilt binary because the release artifacts are the tested ones —
# building from source here would produce a binary we never ran CI against.
class RelaykeyAgent < Formula
  desc "Remote administration agent for machines behind firewalls, over end-to-end encryption"
  homepage "https://github.com/ptrinh/relaykey-public"
  # No `version` stanza: Homebrew scans it from the v0.4.0 in the URLs below,
  # and declaring it again is flagged as redundant by `brew audit`.

  on_macos do
    on_arm do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.0/relaykey-agent-cli-macos-arm64"
      sha256 "7c433a9a483a58a7ec82dfa069ae81ef1c3b7055854781fe1a04cefce02208ff"
    end
    on_intel do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.0/relaykey-agent-cli-macos-amd64"
      sha256 "0ce63ceacd0a086e60db33d3d7308cadda51b8a668954082795bdff4fe6f266e"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.0/relaykey-agent-cli-linux-arm64"
      sha256 "9f4e87da5dca32f98238e5964512211512679244ece4770aa6d88841e20f12e2"
    end
    on_intel do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.0/relaykey-agent-cli-linux-amd64"
      sha256 "2a12e018fde4794938dd3bd4f2244f49889e5f9d66bab53bc8164e87e1325590"
    end
  end

  def install
    # The release asset is named per-platform; install it under the plain name.
    bin.install Dir["relaykey-agent-cli-*"].first => "relaykey"
  end

  def caveats
    <<~EOS
      Installing the binary does not start an agent. To register the system
      service and pair this machine with your client in one step:

        sudo relaykey install -paircode=CODE

      Get CODE from your RelayKey client ("Add machine"), then compare the
      six-digit number shown on both sides before accepting.

      To try it without installing a service or using root:

        relaykey run -dev

      Service management is handled by relaykey itself (launchd on macOS,
      systemd on Linux) rather than `brew services`, so that an agent keeps
      running for the machine rather than for your login session:

        relaykey status
        sudo relaykey uninstall [-purge]
    EOS
  end

  test do
    assert_match "relaykey", shell_output("#{bin}/relaykey version")
  end
end
