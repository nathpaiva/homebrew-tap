class BruRun < Formula
  desc "Run Bruno collection requests from any project, from any directory"
  homepage "https://github.com/nathpaiva/bru-run"
  url "https://github.com/nathpaiva/bru-run/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "10695438165863978be8368a2ce3323947ae6778b75d1357db006c2b80975bfb"
  license "MIT"

  depends_on "bash"
  depends_on "jq"

  def install
    # bin/bru-run resolves its own symlink chain, then loads lib/ as a
    # sibling of its own bin/ dir, so the bin/ + lib/ pair has to stay
    # together.
    libexec.install "bin", "lib"
    # Pin the shebang to Homebrew's bash so macOS system bash 3.2 is never
    # hit: bru-run needs 4.0+ and fails fast otherwise.
    inreplace libexec/"bin/bru-run", %r{^#!/usr/bin/env bash$}, "#!#{formula_opt_bin("bash")}/bash"
    bin.install_symlink libexec/"bin/bru-run"
  end

  def caveats
    <<~EOS
      bru-run sends requests through the Bruno CLI, which is not in Homebrew.
      Install it with npm:
        npm install -g @usebruno/cli

      fzf is optional, only for the interactive request and environment
      pickers:
        brew install fzf
    EOS
  end

  test do
    assert_match "run Bruno collection requests", shell_output("#{bin}/bru-run --help")
  end
end
