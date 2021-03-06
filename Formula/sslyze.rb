class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/7a/c5/92c28ccdd0641c3b5c59b246861f50d738ac0d4a4e0314f9f2700191c464/sslyze-5.0.4.tar.gz"
    sha256 "369adefac083c3ef6ad60b84ffd48c5fd66cfa47d3bd6cdbdf9a546c50123d23"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.2.tar.gz"
      sha256 "440296e07ee021dc283bfe7b810f3139349e26445bc21b5e05820808e15186a2"
      # patch is needed until https://github.com/nabla-c0d3/nassl/pull/89 is merged
      patch do
        url "https://github.com/nabla-c0d3/nassl/commit/f210a0d15d65c6ec11f43d3fef9f6004549bf19a.patch?full_index=1"
        sha256 "270d5a76c8753afa318cd3fa0d53fe29f89786cba57096e384697acc1259552d"
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "c55c4bea4ee7beb0320c1b12d315ae340409b036fee4e630b80e16634b0b4f27"
    sha256 cellar: :any,                 big_sur:      "5e946542c424ed0446128a9fd0287482a4088e1f84a3393c4878e2e0151eaa9d"
    sha256 cellar: :any,                 catalina:     "6ee55f116dd5aae0385167ae2ea634b6e66f984a93983ab2f000d405b8cf15d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24c6d236aa6fc9f1b93f1002fc734eeee0292d24658846822a2e10c97c1c6380"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/60/a3/23a8a9378ff06853bda6527a39fe317b088d760adf41cf70fc0f6110e485/pydantic-1.9.0.tar.gz"
    sha256 "742645059757a56ecd886faf4ed2441b9c0cd406079c2b4bee51bcc3fbcd510a"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end
