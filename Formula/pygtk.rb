class Pygtk < Formula
  desc "GTK+ bindings for Python"
  homepage "http://www.pygtk.org/"
  url "https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2"
  sha256 "cd1c1ea265bd63ff669e92a2d3c2a88eb26bcd9e5363e0f82c896e649f206912"
  revision 3

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "198acf2dbc825deab43c7969d66eb0ed6c59a479a4adbed9eb941db938c7243c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "198acf2dbc825deab43c7969d66eb0ed6c59a479a4adbed9eb941db938c7243c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "198acf2dbc825deab43c7969d66eb0ed6c59a479a4adbed9eb941db938c7243c"
  end

  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "glib"
  depends_on "gtk+"
  depends_on "glade"
  depends_on "py3cairo"
  depends_on "edegp/gimp/pygobject"

  # Allow building with recent Pango, where some symbols were removed
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/pygtk/2.24.0.diff"
    sha256 "ec480cff20082c41d9015bb7f7fc523c27a2c12a60772b2c55222e4ba0263dde"
  end

  def install
    ENV.append "CFLAGS", "-ObjC"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"

    # Fixing the pkgconfig file to find codegen, because it was moved from
    # pygtk to pygobject. But our pkgfiles point into the cellar and in the
    # pygtk-cellar there is no pygobject.
    inreplace lib/"pkgconfig/pygtk-2.0.pc", "codegendir=${datadir}/pygobject/2.0/codegen", "codegendir=#{HOMEBREW_PREFIX}/share/pygobject/2.0/codegen"
    inreplace bin/"pygtk-codegen-2.0", "exec_prefix=${prefix}", "exec_prefix=#{Formula["pygobject"].opt_prefix}"
  end

  test do
    (testpath/"codegen.def").write("(define-enum asdf)")
    system "#{bin}/pygtk-codegen-2.0", "codegen.def"
  end
end
