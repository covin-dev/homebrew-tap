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
  version "0.1.12"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.12/covin-darwin-arm64.tar.gz"
      sha256 "1498d5674a7d0cf1a1005b976f3a44100796cbc2c9a29a5c58c4ccf368e7752f"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.12/covin-darwin-x86_64.tar.gz"
      sha256 "0bf06c0a5decf0dc6fc81afcb26fdd7edd3c33725c033e0533f8eb2917ebd03f"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.12/covin-linux-arm64.tar.gz"
      sha256 "1832ee1f3636d8ef603852ab38c68459e4d078c13865e27acb27d529a1bfdd2a"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.12/covin-linux-x86_64.tar.gz"
      sha256 "c9cdce0508402b18d66de4ba19d80812342b4dd37a8a13f816c7447ce5635be5"
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
