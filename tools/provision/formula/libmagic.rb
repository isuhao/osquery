require File.expand_path("../Abstract/abstract-osquery-formula", __FILE__)

class Libmagic < AbstractOsqueryFormula
  desc "Implementation of the file(1) command"
  homepage "https://www.darwinsys.com/file/"
  url "https://fossies.org/linux/misc/file-5.29.tar.gz"
  sha256 "ea661277cd39bf8f063d3a83ee875432cc3680494169f952787e002bdd3884c0"

  bottle do
    root_url "https://osquery-packages.s3.amazonaws.com/bottles"
    cellar :any_skip_relocation
    sha256 "906e03a38f95e1d5fad4bd540a64bbcdcc7235993cf760b005d15446b16e7be0" => :sierra
    sha256 "bd197ddf2bc1ec309c354a0a5182e0e8620ec9b8c1fda97d34ad19b1748fc5e9" => :el_capitan
    sha256 "1fab0b41cfae9411e0bf622ede55977ecd71cc9336725f4fa64282adf0281998" => :x86_64_linux
  end

  depends_on :python => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-fsect-man5",
                          "--enable-static"
    system "make", "install"
    (share+"misc/magic").install Dir["magic/Magdir/*"]

    if build.with? "python"
      cd "python" do
        system "python", *Language::Python.setup_install_args(prefix)
      end
    end

    # Don't dupe this system utility
    rm bin/"file"
    rm man1/"file.1"
  end
end
