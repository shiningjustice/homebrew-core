class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/f1/0e/7c5d060b0fc6a33739e7a36603c7d8dd0186cf5699e61e05706b4ecca104/gallery_dl-1.21.2.tar.gz"
  sha256 "c67f98f163881face41313b764dc9add907087dd284a34a4d34c5f3b4736dd3a"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8f17955ee2ffa3e69582fe979b8f494bf082e8f07521507a26a4eed229c79d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8f17955ee2ffa3e69582fe979b8f494bf082e8f07521507a26a4eed229c79d9"
    sha256 cellar: :any_skip_relocation, monterey:       "7a858074c718cf0caa2f1e993f75daeb0d23f5f8ce663ad5f7f1d5face0a0b05"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a858074c718cf0caa2f1e993f75daeb0d23f5f8ce663ad5f7f1d5face0a0b05"
    sha256 cellar: :any_skip_relocation, catalina:       "7a858074c718cf0caa2f1e993f75daeb0d23f5f8ce663ad5f7f1d5face0a0b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69fd89a5ab84f50f587dd7bba4703f0d7d613acd42aaa7839fe733196bc3a1ba"
  end

  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
