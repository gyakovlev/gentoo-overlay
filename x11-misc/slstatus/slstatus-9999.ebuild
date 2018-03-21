# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig toolchain-funcs

DESCRIPTION="Status monitor for window managers that use WM_NAME/stdin to fill the status bar"
HOMEPAGE="https://tools.suckless.org/slstatus/"

if [ ${PV} == "9999" ] ; then
	inherit git-r3
	EGIT_REPO_URI="https://git.suckless.org/${PN}"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	sed -i \
		-e '/^CFLAGS/{s: -Os::g; s:= :+= :g}' \
		-e '/^CFLAGS/{s: -Wall::g; s: -Wextra::g}' \
		-e '/^LDFLAGS/{s:-s::g; s:= :+= :g}' \
		-e '/^CC/d' \
		config.mk || die
	sed -i \
		-e 's|@${CC}|$(CC)|g' \
		Makefile || die

	restore_config config.h
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install
	einstalldocs
	save_config config.h
}
