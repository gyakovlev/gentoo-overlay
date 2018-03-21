# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1

DESCRIPTION="View and filter Hacker News from the command line"
HOMEPAGE="https://github.com/donnemartin/haxor-news"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
		>=dev-python/click-5.1[${PYTHON_USEDEP}]
		>=dev-python/colorama-0.3.3[${PYTHON_USEDEP}]
		>=dev-python/requests-2.4.3[${PYTHON_USEDEP}]
		>=dev-python/pygments-2.0.2[${PYTHON_USEDEP}]
		>=dev-python/prompt_toolkit-1.0.0[${PYTHON_USEDEP}]
		>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
		dev-python/setuptools[${PYTHON_USEDEP}]
"

# tests require network https://github.com/donnemartin/haxor-news/issues/129
RESTRICT="test"

src_prepare() {
	rm -rf tests || die
	distutils-r1_src_prepare
}