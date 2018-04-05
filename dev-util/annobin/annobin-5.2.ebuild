# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Binary annotation plugin for GCC"
HOMEPAGE="https://nickc.fedorapeople.org"
SRC_URI="https://nickc.fedorapeople.org/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# NOTE: gcc: depend or not depend? research it.
DEPEND="sys-devel/gcc:="
RDEPEND="${DEPEND}"

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		if ! tc-is-gcc ; then
			eerror "${PN} is a gcc plugin. Please emerge using gcc as CC"
			die "use gcc"
		fi
	fi
}

src_prepare() {
	default
	# FIXME: tighten sed, or use patch. Or find another way around macro version check
	sed -i 's|2.64|2.69|g' config/override.m4 || die
	eautoreconf
}

src_configure() {
	# TODO static libs, pie, etc
	local myconf=(
		# FIXME: it's ugly.
		--with-gcc-plugin-dir=$($(tc-getCC) -print-file-name=plugin)
	)
	econf "${myconf[@]}"
}
