# Installs the prebuilt gitaway release binaries. `scripts/update-formula.py`
# rewrites the version in every `url` and every `sha256` below; don't edit them by hand.
class Gitaway < Formula
  desc "Reach your self-hosted git server from anywhere, with a tunnel only gitaway uses"
  homepage "https://github.com/nikkel/gitaway"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/nikkel/gitaway/releases/download/v0.2.0/gitaway-aarch64-apple-darwin.tar.xz"
      sha256 "91a2daee39a6457db3f812c1c710132e3e77839b04cd4d5ac2584e1947bf84db"
    end
    on_intel do
      url "https://github.com/nikkel/gitaway/releases/download/v0.2.0/gitaway-x86_64-apple-darwin.tar.xz"
      sha256 "ad16234ee2ef60b76aecadd66ab90f5d3293ac1e9c7ea92f8146f8ff9c993b25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nikkel/gitaway/releases/download/v0.2.0/gitaway-aarch64-unknown-linux-musl.tar.xz"
      sha256 "ec131713bcc9507d1218da0b8ddfca582f6e547d6636318f4e91746ed33bd274"
    end
    on_intel do
      url "https://github.com/nikkel/gitaway/releases/download/v0.2.0/gitaway-x86_64-unknown-linux-musl.tar.xz"
      sha256 "7c37d1b4ea88190a61f23ad0d2b0c9ac7a8ad3d93ec734f29e206b68da7e0747"
    end
  end

  def install
    bin.install "gitaway"
    bin.install_symlink "gitaway" => "git-away"
    man1.install Dir["dist-man/*.1"]
    doc.install "README.md", "CHANGELOG.md", "LICENSE-MIT", "LICENSE-APACHE"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitaway --version")
    assert_match version.to_s, shell_output("#{bin}/git-away --version")
  end
end
