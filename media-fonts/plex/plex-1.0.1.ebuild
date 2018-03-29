# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

SRC_URI="https://github.com/IBM/${PN}/releases/download/v${PV}/TrueType.zip -> ibm-${P}-ttf.zip"

DESCRIPTION="IBM's plex typeface"
HOMEPAGE="https://github.com/IBM/plex"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="binchecks strip"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/TrueType"
MY_FONT_A=( IBM-Plex-{Mono,Sans,Sans-Condensed,Serif} )
FONT_S="${S}/${MY_FONT_A[@]}"
FONT_SUFFIX="ttf"
