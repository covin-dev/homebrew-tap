# Homebrew formula for Covin Local: the prebuilt binary from covin.dev/dl (no Python, no build).
# Template: it lives in this repo and is copied to the tap repo covin-dev/homebrew-tap (Formula/covin.rb),
# which serves `brew install covin-dev/tap/covin`. (github.com/covin is an unrelated user.)
#
# After each release, set version/url/sha256 for every platform from that release's manifest with:
#   packaging/homebrew/update-formula.sh <version>
# The values below are placeholders until the first release is published.
class Covin < Formula
  desc "On-device guard that checks what your coding agents do against your task"
  homepage "https://covin.dev"
  version "0.1.11"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.11/covin-darwin-arm64.tar.gz"
      sha256 "3396a757af5b04e23e193bc24ef9131094779fcc5ce0c55f36a4a58852878d46"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.11/covin-darwin-x86_64.tar.gz"
      sha256 "926697f8747d9d1829fc42a5ec7f91f296138dfe10a443f8d72585202c9afc2b"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.11/covin-linux-arm64.tar.gz"
      sha256 "893538ae8be549f06577a0b1f1c3d9479c184569b20c8cbd5551286d57b9eb57"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.11/covin-linux-x86_64.tar.gz"
      sha256 "a50dd961f45d7018b2f6f22de742b5048f953db436284c8e4f270ebf10fb355e"
    end
  end

  def install
    # The executable finds its libs next to itself (Nuitka standalone): keep the directory together in libexec.
    libexec.install Dir["*"]
    bin.install_symlink libexec/"covin"
  end

  def caveats
    <<~EOS
      Hook Covin into your coding agents and connect this machine (it asks before changing anything):
        covin setup
      Before `brew uninstall covin`, run `covin uninstall` to restore your agents' configs.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/covin --version")
    ENV["HOME"] = testpath
    system bin/"covin", "doctor"
  end
end
