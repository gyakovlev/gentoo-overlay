# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit golang-build

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/evilsocket/${PN}.git"
else
	SRC_URI="none yet"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Linux port of the Little Snitch application firewall"
HOMEPAGE="https://www.opensnitch.io"

LICENSE="GPL-3"
SLOT="0"
IUSE="+daemon +qt5"

DEPEND="dev-go/glide
	dev-libs/protobuf
	net-libs/libpcap
	net-libs/libnetfilter_queue"
RDEPEND="${DEPEND}"

RESTRICT="test" # does some stupid sudo pip installs
