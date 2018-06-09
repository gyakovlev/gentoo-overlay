# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit distutils-r1

DESCRIPTION="GRPC Python package"
HOMEPAGE="https://grpc.io/"
# TODO: switch to GH tarball and merge with net-libs/grpc?
# TODO: or maybe just switch but do not merge ebuilds?
# TODO: it's named grpc for net-libs, but it's grpcio here, mirroring pypi name
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
#SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples"

# TODO: verify [r]deps
# TODO: is -bindist is really needed on openssl?
# TODO: libressl?
DEPEND="
	>=dev-libs/openssl-1.0.2:0=[-bindist]
	>=dev-libs/protobuf-3:=
	net-dns/c-ares:=
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/cython[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3.5.1:=[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	sys-libs/zlib:=
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
"

RDEPEND="${DEPEND}
	virtual/python-enum34[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]
"

PATCHES=(
	# backported from master, check if merged at next bump
	"${FILESDIR}/${P}"-allow-system-openssl.patch
	"${FILESDIR}/${P}"-allow-system-zlib.patch
	"${FILESDIR}/${P}"-allow-system-cares.patch
)

python_configure_all() {
	# TODO: do I need use flags for all of this? Hope not.
	# TODO: check openssl/libressl deps and use
	# TODO: if it does not build with libressl, it may be
	# TODO: appropriate to use bundled one in that case.
	export GRPC_PYTHON_BUILD_WITH_CYTHON=1
	export GRPC_PYTHON_BUILD_SYSTEM_OPENSSL=1
	export GRPC_PYTHON_BUILD_SYSTEM_ZLIB=1
	export GRPC_PYTHON_BUILD_SYSTEM_CARES=1
	# TODO: sphinx and friends
	#use doc && export GRPC_PYTHON_ENABLE_DOCUMENTATION_BUILD=1
	# TODO: cc1plus: warning: command line option ‘-std=gnu99’ is valid for C/ObjC but not for C++
}

# TODO: tests

python_install_all() {
# TODO: this is not in pypi tarball. but github repo/tarball has it
#	if use examples; then
#		docinto examples
#		dodoc -r samples/python/.
#	fi
	distutils-r1_python_install_all
}
