# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils

DESCRIPTION="Windows XP BSOD emulation for console."
HOMEPAGE="http://www.vanheusden.com/bsod/"
SRC_URI="http://www.vanheusden.com/bsod/${PN}-0.1.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.1-makefile.patch"
}
src_compile() {
	emake || die
}
src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install || die "install failed"
}
