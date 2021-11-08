# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="News reader for your terminal"
HOMEPAGE="https://github.com/tomschwarz/neix"
SRC_URI="https://github.com/tomschwarz/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~ppc64"
IUSE="test"

DEPEND="
	sys-libs/ncurses:=[unicode(+)]
	net-misc/curl:=
"
RDEPEND="${DEPEND}"
BDEPEND="test? ( dev-vcs/git )"

# downloads gtest source at configure time, so
# PROPERTIES="test_network" will not work
RESTRICT="test"

src_configure() {
	local mycmakeargs=( -DENABLE-TESTS="$(usex test ON OFF)" )
	cmake_src_configure
}

src_test() {
	cd ${BUILD_DIR} || die
	./bin/tests || die
}
