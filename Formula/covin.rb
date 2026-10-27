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
  version "0.1.18"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.18/covin-darwin-arm64.tar.gz"
      sha256 "01e71affa08bc5655606e1a3b02f8d132502eb4f42097f6b70da19ffa2d86b3b"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.18/covin-darwin-x86_64.tar.gz"
      sha256 "5bdbf70ddcea1444be9488caaa0e576eba33554984cc29ac6efe4dbf100bd25c"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.18/covin-linux-arm64.tar.gz"
      sha256 "4d44b4769af3de77e4bbde7a069fef0695e8630762ac67f573dfccc122f6f358"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.18/covin-linux-x86_64.tar.gz"
      sha256 "aaf21a5866986b78f0b47cc3225448e77287c917c8705148370ed9472cdb2e06"
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
