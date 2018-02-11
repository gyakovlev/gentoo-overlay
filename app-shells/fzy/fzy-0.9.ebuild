# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit savedconfig

DESCRIPTION="Fast, fuzzy text selector with an advanced scoring algorithm"
HOMEPAGE="https://github.com/jhawthorn/fzy"
SRC_URI="https://github.com/jhawthorn/fzy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="test"

KEYWORDS="~amd64 ~x86"

src_prepare() {
	eapply_user
	sed -i  -e '/^CFLAGS/s/ -O3//' Makefile || die "sed failed"
	restore_config config.h
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	exeinto /usr/share/fzy
	doexe contrib/fzy-tmux
	doexe contrib/fzy-dvtm
	local DOCS=( ALGORITHM.md CHANGELOG.md README.md )
	einstalldocs
	save_config config.h
}