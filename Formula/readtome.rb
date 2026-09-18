class Readtome < Formula
  desc "Read a markdown file out loud with the macOS say command"
  homepage "https://github.com/nathpaiva/readtome"
  url "https://github.com/nathpaiva/readtome/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "919bb15a3a125fac4bb3ee309bc55eeb8f2d52c6629fd6162e6ab34a3645243c"
  license "MIT"

  # `say` ships with macOS and exists nowhere else.
  depends_on :macos
  depends_on "python@3.13"

  def install
    # cli.py puts its own folder on sys.path and imports its four siblings,
    # so the five files have to stay together.
    libexec.install Dir["*.py"]
    # Pin the shebang to Homebrew's python, so the tool never depends on
    # whichever python3 happens to come first on the PATH.
    inreplace libexec/"cli.py", %r{^#!/usr/bin/env python3$},
              "#!#{formula_opt_bin("python@3.13")}/python3.13"
    bin.install_symlink libexec/"cli.py" => "readtome"
  end

  def caveats
    <<~EOS
      English reads with Samantha. The enhanced Samantha sounds much less
      robotic and is a free download, in System Settings > Accessibility >
      Spoken Content > System Speech Voice > Manage Voices. readtome picks
      it up on its own once it is there, with nothing to configure.

      To pick a project by name with -p, say where your repos live:
        export READTOME_ROOTS="$HOME/code:$HOME/work"

      fzf is optional, only for the branch and file menus. Without it they
      print numbered rows instead:
        brew install fzf
    EOS
  end

  test do
    (testpath/"doc.md").write("# A heading\n\nOne sentence here.\n")
    assert_match "# A heading",
                 shell_output("#{bin}/readtome #{testpath}/doc.md --list")
  end
end
