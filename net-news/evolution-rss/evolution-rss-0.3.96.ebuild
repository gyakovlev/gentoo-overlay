# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P//-/_}"
MY_P="${MY_P//./_}"
MY_P="${MY_P^^}"
GNOME2_EAUTORECONF=yes

inherit gnome2

DESCRIPTION="Evolution mail plugin which enables it to read rss feeds"
HOMEPAGE="https://gitlab.gnome.org/GNOME/evolution-rss/"
SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${MY_P}/${PN}-${MY_P}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~arm64 ~ppc64"
IUSE="nls"

DEPEND="
	>=dev-libs/glib-2.16.2:2
	>=dev-libs/libxml2-2.7.3:2
	gnome-extra/evolution-data-server:0=
	mail-client/evolution:2.0
	net-libs/libsoup:2.4
	net-libs/webkit-gtk:4
	>=x11-libs/gdk-pixbuf-2.24:2
	x11-libs/gtk+:3
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-util/gdbus-codegen
	dev-util/glib-utils
	virtual/pkgconfig
	nls? (
		>=dev-util/intltool-0.40.0
		>=sys-devel/gettext-0.18.0
	)
"

S="${WORKDIR}/${PN}-${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-combofix.patch"
	"${FILESDIR}/dont-require-gconf.patch"
	"${FILESDIR}/deprecated.patch"
)

src_configure() {
	local myconf=(
		--disable-gecko
		--enable-webkit
		--with-primary-render=webkit
		$(use_enable nls)
	)
	gnome2_src_configure ${myconf[@]}
}

src_install() {
	gnome2_src_install
	einstalldocs
}
