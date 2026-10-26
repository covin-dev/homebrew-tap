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
  version "0.1.17"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.17/covin-darwin-arm64.tar.gz"
      sha256 "6fbcfbf5739eca4c50b1bfd1911a55a6383f6ea59aaae8e3f3c9fa748c96ed0c"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.17/covin-darwin-x86_64.tar.gz"
      sha256 "bcdbbf8092e1fce8cf6af634c04f06b9045a65df6c6d73b1f0dc64f6b0c75580"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.17/covin-linux-arm64.tar.gz"
      sha256 "66e8e296b32c6ff734016b829873e9e373766babee200bdfd65ebedc8345202e"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.17/covin-linux-x86_64.tar.gz"
      sha256 "be6380f0ed150628d331717ad694451f7ee1bb92fba72bcbf1147bb61649d913"
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
