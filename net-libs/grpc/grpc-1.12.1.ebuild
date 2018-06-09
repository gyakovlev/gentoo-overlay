# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
DISTUTILS_OPTIONAL=1

inherit distutils-r1 toolchain-funcs multilib flag-o-matic

DESCRIPTION="Modern open source high performance RPC framework"
HOMEPAGE="http://www.grpc.io"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	>=dev-libs/protobuf-3:=
	net-dns/c-ares:=
	sys-libs/zlib:=
	python? (
		virtual/python-enum34[${PYTHON_USEDEP}]
		virtual/python-futures[${PYTHON_USEDEP}]
	)
"

DEPEND="${RDEPEND}
	python? ( ${PYTHON_DEPS}
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/cython[${PYTHON_USEDEP}]
		>=dev-python/protobuf-python-3.5.1:=[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	"${FILESDIR}/0001-grpc-1.11.0-Fix-cross-compiling.patch"
	"${FILESDIR}/0002-grpc-1.3.0-Fix-unsecure-.pc-files.patch"
	"${FILESDIR}/0003-grpc-1.3.0-Don-t-run-ldconfig.patch"
	"${FILESDIR}/0004-grpc-1.11.0-fix-cpp-so-version.patch"
	"${FILESDIR}/0005-grpc-1.11.0-pkgconfig-libdir.patch"
	"${FILESDIR}"/grpcio-1.12.1-allow-system-openssl.patch
	"${FILESDIR}"/grpcio-1.12.1-allow-system-zlib.patch
	"${FILESDIR}"/grpcio-1.12.1-allow-system-cares.patch
)

src_prepare() {
	sed -i 's@$(prefix)/lib@$(prefix)/$(INSTALL_LIBDIR)@g' Makefile || die "fix libdir"
	default
	use python && distutils-r1_src_prepare
}

src_configure() {
	default
	if use python; then
		export GRPC_PYTHON_BUILD_WITH_CYTHON=1
		export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
		export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
		export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
		distutils-r1_src_configure
	fi
}
src_compile() {
	tc-export CC CXX PKG_CONFIG
	emake \
		V=1 \
		prefix=/usr \
		INSTALL_LIBDIR="$(get_libdir)" \
		AR="$(tc-getAR)" \
		AROPTS="rcs" \
		CFLAGS="${CFLAGS}" \
		LD="${CC}" \
		LDXX="${CXX}" \
		STRIP=true \
		HOST_CC="$(tc-getBUILD_CC)" \
		HOST_CXX="$(tc-getBUILD_CXX)" \
		HOST_LD="$(tc-getBUILD_CC)" \
		HOST_LDXX="$(tc-getBUILD_CXX)" \
		HOST_AR="$(tc-getBUILD_AR)"
	use python && distutils-r1_src_compile
}

src_install() {
	emake \
		prefix="${D}"/usr \
		INSTALL_LIBDIR="$(get_libdir)" \
		STRIP=true \
		install
	use python && distutils-r1_src_install
}