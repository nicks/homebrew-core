class Flann < Formula
  desc "Fast Library for Approximate Nearest Neighbors"
  homepage "https://github.com/mariusmuja/flann"
  url "https://github.com/mariusmuja/flann/archive/1.9.1.tar.gz"
  sha256 "b23b5f4e71139faa3bcb39e6bbcc76967fbaf308c4ee9d4f5bfbeceaa76cc5d3"
  license "BSD-3-Clause"
  revision 9

  bottle do
    cellar :any
    sha256 "8bee2438249ae71560fb12fd9d2b7b8a63f09d29f09d11628f8603a4c3f14d8d" => :catalina
    sha256 "234f35c606e1d5a6420a8ad8b26ef40234497caf757358063a71dd672d0436da" => :mojave
    sha256 "f23d114ea25d8dcf60d14a829d79293b6bc1b868900c8a0abae25c0c45a68bba" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "hdf5"

  on_linux do
    # Fix for Linux build: https://bugs.gentoo.org/652594
    # Not yet fixed upstream: https://github.com/mariusmuja/flann/issues/369
    patch do
      url "https://raw.githubusercontent.com/buildroot/buildroot/0c469478f64d0ddaf72c0622a1830d855306d51c/package/flann/0001-src-cpp-fix-cmake-3.11-build.patch"
      sha256 "aa181d0731d4e9a266f7fcaf5423e7a6b783f400cc040a3ef0fef77930ecf680"
    end
  end

  resource("dataset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.dat"
    sha256 "dcbf0268a7ff9acd7c3972623e9da722a8788f5e474ae478b888c255ff73d981"
  end

  resource("testset.dat") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/testset.dat"
    sha256 "d9ff91195bf2ad8ced78842fa138b3cd4e226d714edbb4cb776369af04dda81b"
  end

  resource("dataset.hdf5") do
    url "https://www.cs.ubc.ca/research/flann/uploads/FLANN/datasets/dataset.hdf5"
    sha256 "64ae599f3182a44806f611fdb3c77f837705fcaef96321fb613190a6eabb4860"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_PYTHON_BINDINGS:BOOL=OFF", "-DBUILD_MATLAB_BINDINGS:BOOL=OFF"
    system "make", "install"
  end

  test do
    resource("dataset.dat").stage testpath
    resource("testset.dat").stage testpath
    resource("dataset.hdf5").stage testpath
    system "#{bin}/flann_example_c"
    system "#{bin}/flann_example_cpp"
  end
end
