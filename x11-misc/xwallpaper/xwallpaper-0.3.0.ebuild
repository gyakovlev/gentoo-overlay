# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="The xwallpaper utility allows you to set image files as your X wallpaper."
HOMEPAGE="https://github.com/stoeckmann/xwallpaper"
SRC_URI="https://github.com/stoeckmann/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="jpeg png seccomp xpm +xrandr"

DEPEND="jpeg? ( virtual/jpeg:0 )
		png? ( >=media-libs/libpng-1.2 )
		seccomp? ( >=sys-libs/libseccomp-2.3.1 )
		xpm? ( >=x11-libs/libXpm-3.5 )
		>=x11-libs/pixman-0.32
		>=x11-libs/xcb-util-0.3.8
		>=x11-libs/xcb-util-image-0.3.8"
RDEPEND="${DEPEND}"

src_prepeare() {
	eautoreconf
}
src_configure() {
	econf \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with seccomp) \
		$(use_with xpm) \
		$(use_with xrandr randr)
}
