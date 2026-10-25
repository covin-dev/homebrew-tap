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
  version "0.1.15"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.15/covin-darwin-arm64.tar.gz"
      sha256 "b5d8db13f54f794e57273ace931fd181792fe01d93722561c91be51fc5f194e4"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.15/covin-darwin-x86_64.tar.gz"
      sha256 "75c802b3b7b51595a8c8300e3b9fd40d49383faa9e8bb0f972c27a51d283e0ea"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.15/covin-linux-arm64.tar.gz"
      sha256 "b6fd3b1fc8d7c6a8e99cd282585a8e7ea306e521c16b23656b6d733d566576e7"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.15/covin-linux-x86_64.tar.gz"
      sha256 "bf5cc0348fdc99958167e2af82ee7ad633320b73c3ce55272a12d3faec2b32a5"
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
