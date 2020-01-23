# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit cmake desktop flag-o-matic python-any-r1 xdg-utils

MY_P="tdesktop-${PV}-full"

DESCRIPTION="Official desktop client for Telegram"
HOMEPAGE="https://desktop.telegram.org"
SRC_URI="https://github.com/telegramdesktop/tdesktop/releases/download/v${PV}/${MY_P}.tar.gz"

LICENSE="GPL-3-with-openssl-exception Unlicense"
SLOT="0"
KEYWORDS=""
IUSE="dbus gtk3 spell"

RDEPEND="${PYTHON_DEPS}
	!net-im/telegram-desktop-bin
	app-arch/lz4
	app-arch/xz-utils
	dev-libs/openssl:0
	dev-libs/xxhash
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5[jpeg,png,X]
	dev-qt/qtimageformats:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5[png,X]
	media-libs/openal[pulseaudio]
	media-libs/opus
	media-sound/pulseaudio
	sys-libs/zlib[minizip]
	virtual/ffmpeg
	x11-libs/libva[X,drm]
	x11-libs/libX11
	dbus? ( sys-apps/dbus )
	gtk3? (
		dev-libs/libappindicator:3
		x11-libs/gtk+:3
	)
	spell? ( app-text/enchant )
"

DEPEND="${RDEPEND}"

BDEPEND="
	>=dev-util/cmake-3.16
"

PATCHES=( "${FILESDIR}/ppc.patch" )

S="${WORKDIR}/${MY_P}"

src_configure() {
	local mycxxflags=(
		-Wno-deprecated-declarations
		-Wno-error=deprecated-declarations
		-Wno-switch
	)

	append-cxxflags "${mycxxflags[@]}"

	# TODO: while test api works, add support specifying
	# api via /etc/portage/env or similar just environment

	# FIXME: using bundled rlottie, as there's no stable ABI yet 

	# TODO: figure out how to rip pulse out, it's possible to edit
	# it's cmake  file and it has knob to toggle between alsa/pulse

	# TODO: support gtk filepicker forcing

	local mycmakeargs=(
		-DTDESKTOP_API_TEST=ON
		-DDESKTOP_APP_DISABLE_CRASH_REPORTS=ON
		-DDESKTOP_APP_USE_GLIBC_WRAPS=OFF
		-DDESKTOP_APP_USE_PACKAGED_RLOTTIE=OFF
		-DTDESKTOP_APP_DISABLE_SPELLCHECK="$(usex spell OFF ON)"
		-DTDESKTOP_DISABLE_GTK_INTEGRATION="$(usex gtk3 OFF ON)"
		-DTDESKTOP_DISABLE_DBUS_INTEGRATION="$(usex dbus OFF ON)"
		-DTDESKTOP_LAUNCHER_BASENAME="${PN}"
		-DTDESKTOP_USE_PACKAGED_TGVOIP=OFF
		-DTDESKTOP_DISABLE_DESKTOP_FILE_GENERATION=ON
		-Ddisable_autoupdate=1
	)
	cmake_src_configure
}

src_install() {
	newbin "${BUILD_DIR}"/bin/Telegram ${PN}

	newmenu lib/xdg/telegramdesktop.desktop "${PN}.desktop"

	local icon_size
	for icon_size in 16 32 48 64 128 256 512
	do
		newicon -s ${icon_size} \
			Telegram/Resources/art/icon${icon_size}.png telegram.png
	done

	insinto /usr/share/appdata
	doins lib/xdg/telegramdesktop.appdata.xml

	insinto /usr/share/kservices5
	doins lib/xdg/tg.protocol

	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_icon_cache_update
	xdg_mimeinfo_database_update
}
