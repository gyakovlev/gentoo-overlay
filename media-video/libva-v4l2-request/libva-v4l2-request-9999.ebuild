# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 meson

DESCRIPTION="v4l2-request libVA Backend"
HOMEPAGE="https://github.com/bootlin/libva-v4l2-request"
EGIT_REPO_URI="https://github.com/bootlin/libva-v4l2-request.git"

LICENSE="LGPL-2.1 MIT"
SLOT="0"
KEYWORDS=""

RDEPEND="
	x11-libs/libdrm
	x11-libs/libva:=
"
DEPEND="
	${RDEPEND}
	virtual/os-headers
"
BDEPEND=""

PATCHES=( "${FILESDIR}/kernel-compat.patch" )
