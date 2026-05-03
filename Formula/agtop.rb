class Agtop < Formula
  desc "Terminal UI for monitoring AI coding agents (Claude Code, Codex, Aider, ...)"
  homepage "https://github.com/mbrassey/agtop"
  # The url + sha256 lines are templated on every release by
  # `.github/workflows/release.yml::publish-homebrew`; the @mbrassey/tap
  # mirror is what `brew install mbrassey/tap/agtop` actually consumes.
  # The committed values here are kept in sync so a `brew install` against
  # this file directly also succeeds.
  url "https://github.com/mbrassey/agtop/archive/refs/tags/v2.4.9.tar.gz"
  sha256 "8b5e94d9cc00eac07ada4c7c9bf4181422eaf7922af8c47d6cb3de009a2e0977"
  license "MIT"
  head "https://github.com/mbrassey/agtop.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    # Ship man page + completions if the build emitted them.
    man1.install "target/release/build/agtop.1" if File.exist?("target/release/build/agtop.1")
    bash_completion.install "target/release/build/agtop.bash" => "agtop" if
      File.exist?("target/release/build/agtop.bash")
    zsh_completion.install  "target/release/build/_agtop"     if
      File.exist?("target/release/build/_agtop")
    fish_completion.install "target/release/build/agtop.fish" if
      File.exist?("target/release/build/agtop.fish")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/agtop --version")
    assert_match "claude",     shell_output("#{bin}/agtop --list-builtins")
  end
end
