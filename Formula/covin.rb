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
  version "0.1.9"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.9/covin-darwin-arm64.tar.gz"
      sha256 "c87dec79e852fa83eb5fb3e2fda7f75ee0d73f94b9e963e20162e7e543a0622d"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.9/covin-darwin-x86_64.tar.gz"
      sha256 "bf49caf7aae8304dfce7a9547d979ea99b916336dd7642971b8ae6a4970c9401"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.9/covin-linux-arm64.tar.gz"
      sha256 "7a8f79071a5f2408cafc106594a103e7589d57cd06d3b6236f06a9c9f0bce4fb"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.9/covin-linux-x86_64.tar.gz"
      sha256 "90d03dd49e2da102e2d21fd3d551d0e0b615534b45928e50edabc4d09a05481c"
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
