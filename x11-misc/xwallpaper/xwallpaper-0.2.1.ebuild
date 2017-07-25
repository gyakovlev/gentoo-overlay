# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The xwallpaper utility allows you to set image files as your X wallpaper."
HOMEPAGE="https://github.com/stoeckmann/xwallpaper"
SRC_URI="https://github.com/stoeckmann/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg png xpm"

DEPEND="jpeg? ( virtual/jpeg:0 )
		png? ( media-libs/libpng:0 )
		xpm? ( x11-libs/libXpm )
		x11-libs/pixman
		x11-libs/xcb-util-image"
RDEPEND="${DEPEND}"

src_prepeare() {
	eautoreconf
}
src_configure() {
	econf \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with xpm)
}
