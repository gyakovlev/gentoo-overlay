# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Fast, fuzzy text selector with an advanced scoring algorithm"
HOMEPAGE="https://github.com/jhawthorn/fzy"
SRC_URI="https://github.com/jhawthorn/fzy/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -i  -e '/^CFLAGS/s/ -O3//' Makefile || die "sed failed"
	eapply_user
}

src_install() {
	emake PREFIX="${ED}/usr" install
}