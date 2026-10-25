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
  version "0.1.14"
  license :cannot_represent # end-user licence (EULA.txt in the archive)

  on_macos do
    on_arm do
      url "https://covin.dev/dl/0.1.14/covin-darwin-arm64.tar.gz"
      sha256 "aad6d45291400f0e9e441b448336c7b135ccc91d8341e8f026b0825e26ff3990"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.14/covin-darwin-x86_64.tar.gz"
      sha256 "5f65f80b71ebf99295ad39004c4d0a4909445920b2674e473c6d9448945f26ba"
    end
  end

  on_linux do
    on_arm do
      url "https://covin.dev/dl/0.1.14/covin-linux-arm64.tar.gz"
      sha256 "de0dfc865b72354dac65d39f28f9ae3bbb927764394af87e71b1eaeac77d6d22"
    end
    on_intel do
      url "https://covin.dev/dl/0.1.14/covin-linux-x86_64.tar.gz"
      sha256 "2409d2a9ef8e7aeb19b30f865ac75614dbbc6d834914450b9418ccb03963495e"
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
