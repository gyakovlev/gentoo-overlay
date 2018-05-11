# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools toolchain-funcs

DESCRIPTION="Binary annotation plugin for GCC"
HOMEPAGE="https://nickc.fedorapeople.org"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://sourceware.org/git/${PN}.git"
else
	SRC_URI="https://nickc.fedorapeople.org/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

# NOTE: gcc: depend or not depend? research it.
# TODO: slot it or do something else so it can be installed for multiple gcc versions.
DEPEND=">=sys-devel/gcc-7.3.0:="
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
		--with-gcc-plugin-dir=$($(tc-getCC) -print-file-name=plugin)
	)
	econf "${myconf[@]}"
}
