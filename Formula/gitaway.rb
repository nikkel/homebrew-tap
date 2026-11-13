# Installs the prebuilt gitaway release binaries. `scripts/update-formula.py`
# rewrites the version in every `url` and every `sha256` below; don't edit them by hand.
class Gitaway < Formula
  desc "Reach your self-hosted git server from anywhere, with a tunnel only gitaway uses"
  homepage "https://github.com/nikkel/gitaway"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/nikkel/gitaway/releases/download/v0.1.1/gitaway-aarch64-apple-darwin.tar.xz"
      sha256 "e9633b6e67e64ef39263d0ed6c3348d115ad64be09040fe5edc54883ef878dbe"
    end
    on_intel do
      url "https://github.com/nikkel/gitaway/releases/download/v0.1.1/gitaway-x86_64-apple-darwin.tar.xz"
      sha256 "abb697f590543fa19eade5ec295b6347d2713ae94682a6883123215ec9bb4f09"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nikkel/gitaway/releases/download/v0.1.1/gitaway-aarch64-unknown-linux-musl.tar.xz"
      sha256 "53a659bfe8d654c18babe942c75a143d4cd10c3ab2186fd9269dde00102c5379"
    end
    on_intel do
      url "https://github.com/nikkel/gitaway/releases/download/v0.1.1/gitaway-x86_64-unknown-linux-musl.tar.xz"
      sha256 "bd9eff340d16283e76d093bb12417b8bd260dec4bd762bf832f3265b921431b0"
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
