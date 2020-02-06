# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils meson

EGIT_COMMIT="570a2d1a65e77d42cb19e5972d0d1b84"
DESCRIPTION="Application Menu GTK+ Module"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/${EGIT_COMMIT}/${P}.tar.xz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~ppc64"
IUSE=""

RDEPEND="
	dev-libs/glib
	x11-libs/gtk+:2
	x11-libs/gtk+:3
"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
"

BDEPEND=""

#REQUIRED_USE="|| ( gtk gtk3 )"

src_configure() {
	#local -a gtks=()
	#use gtk  && gtks+=( 2 )
	#use gtk3 && gtks+=( 3 )
	#local emesonargs=(
	#	-Dgtk="$(IFS=,; echo "${gtks[*]}")"
	#)
	meson_src_configure
}

src_install() {
	meson_src_install
	rm -r "${ED}/usr/share/${PN}/doc" || die
	einstalldocs
	docompress /usr/share/doc/"${PF}"
}

pkg_postinst() {
	gnome2_schemas_update
}

pkg_postrm() {
	gnome2_schemas_update
}
