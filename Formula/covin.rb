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
  version "0.1.19"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.19/covin-darwin-arm64.tar.gz"
      sha256 "dbc7a3ae1373b2ff752b703725c9c30952ebfe02995bf6125f50b8800861ede2"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.19/covin-darwin-x86_64.tar.gz"
      sha256 "ff49edbe1fdb44dcfa5ab2d2d1949507a5053eaf0f2d243f10fb04c0b586a003"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.19/covin-linux-arm64.tar.gz"
      sha256 "6f47f382fe1ac98666f7881bfbbe033092ae107587fa9e8cf7c04768c166de3d"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.19/covin-linux-x86_64.tar.gz"
      sha256 "82b907c20ae2becaf4f4a119419b318f4acf8caf08c723f407b1240f24754d9c"
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
