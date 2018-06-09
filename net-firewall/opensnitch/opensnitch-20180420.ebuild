# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

EGIT_COMMIT="f71d8ce52f79db97f66782c37a2e6506b96e02ad"
DISTUTILS_SINGLE_IMPL=true

inherit distutils-r1

DESCRIPTION="Linux port of the Little Snitch application firewall (ui)"
HOMEPAGE="https://www.opensnitch.io"
SRC_URI="https://github.com/evilsocket/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+daemon"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}
	net-libs/grpc
	dev-python/configparser
	dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/unicode-slugify[${PYTHON_USEDEP}]
	dev-python/PyQt5[gui,widgets,${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	daemon? ( net-firewall/opensnitchd )"

S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

src_prepare() {
	default
	mv ui/* ./ || die
}
