class GoenvAT2 < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.39.tar.gz"
  sha256 "9c5571e731c1bbf4f6cc1d3606da1960ba56cf0ce1206c58a74e52e6df430e35"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(2\.\d+\.\d+)$/i)
  end

  keg_only :versioned_formula

  # End-of-support on 2028-12-31: https://github.com/go-nv/goenv/pull/525
  disable! date: "2028-12-31", because: :versioned_formula

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
      "plugins/go-build/test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Warning: no Go detected on the system", shell_output("#{bin}/goenv versions 2>&1", 1)
  end
end
