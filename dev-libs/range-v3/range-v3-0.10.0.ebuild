# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Range library for C++14/17/20, basis for C++20's std::ranges"
HOMEPAGE="https://github.com/ericniebler/range-v3"
SRC_URI="https://github.com/ericniebler/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~ppc64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	sed -i 's/ranges_append_flag(RANGES_HAS_WERROR -Werror)//' cmake/ranges_flags.cmake || die
	cmake_src_prepare
}

src_configure() {
	mycmakeargs=(
		-DRANGES_NATIVE=OFF
	)
	cmake_src_configure
}
