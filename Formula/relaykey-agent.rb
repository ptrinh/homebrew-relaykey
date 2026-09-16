# The RelayKey agent: runs ON a machine you want to administer remotely.
# Ships as a prebuilt binary because the release artifacts are the tested ones —
# building from source here would produce a binary we never ran CI against.
class RelaykeyAgent < Formula
  desc "Remote administration agent for machines behind firewalls"
  homepage "https://github.com/ptrinh/relaykey-public"
  # Proprietary: the published binaries may be downloaded and run, but the
  # software is not redistributable and the source is not public.
  license :cannot_represent
  # No `version` stanza: Homebrew scans it from the v0.4.1 in the URLs below,
  # and declaring it again is flagged as redundant by `brew audit`.

  on_macos do
    on_arm do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.1/relaykey-agent-cli-macos-arm64"
      sha256 "c74cd2af3f8a7206cab23ba15af565bffe7d1f3eacaeb6b153b57c89681a72d0"
    end
    on_intel do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.1/relaykey-agent-cli-macos-amd64"
      sha256 "4fdccc138cc055a0dab6bbc1e05fddbe256b46edcd367b4fb4efed4f406fd761"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.1/relaykey-agent-cli-linux-arm64"
      sha256 "89c6b72f04bd279ae78d816808cad7ef5e4a466b4b60a7b4c67fbcb497180692"
    end
    on_intel do
      url "https://github.com/ptrinh/relaykey-public/releases/download/v0.4.1/relaykey-agent-cli-linux-amd64"
      sha256 "c3bcd7e8bd7897d431744b2a0556ab6702d9eb7346b31271bf39f1ca4c605b4a"
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
