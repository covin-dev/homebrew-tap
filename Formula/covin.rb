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
  version "0.1.4"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.4/covin-darwin-arm64.tar.gz"
      sha256 "afc87af9b5065cdd1e4fe5d5ad82af099aa6a9c2e9936daef45ab5190bd5dd12"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.4/covin-darwin-x86_64.tar.gz"
      sha256 "e41f3e026d3a7ebf89fbebe464f24f8f1dd040074b27beb5cc8c6ae8e5ae0be6"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.4/covin-linux-arm64.tar.gz"
      sha256 "e1cfbe35205ce12202d6a8b39de94beab01953eea5ee9a1e626815ea10bd27a0"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.4/covin-linux-x86_64.tar.gz"
      sha256 "4e58c72e888be021f5ff1d84d93cc0a1b33b402d877b3c93c8c39407b16d60a2"
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
