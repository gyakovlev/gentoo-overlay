# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Firmware for the Apple Facetime HD Camera"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-arch/cpio
	app-arch/gzip
	app-arch/xz-utils
	net-misc/curl
	sys-apps/coreutils
"
RDEPEND="${DEPEND}"

S=${WORKDIR}

PKG_URL="https://support.apple.com/downloads/DL1849/en_US/osxupd10.11.2.dmg"

# xz stream #31 from OSXUpdCombo10.11.2.pkg/Payload (part 4)
# = xz stream #33 from OSXUpd10.11.2.pkg (part 2)
# inside osxupd10.11.2.dmg
PKG_RANGE="420107885-421933300"

CAM_IF_FILE="AppleCameraInterface"
CAM_IF_PKG_PATH="./System/Library/Extensions/AppleCameraInterface.kext/Contents/MacOS/AppleCameraInterface"
CAM_IF_MD5="ccea5db116954513252db1ccb639ce95"

FIRMWARE_OFFSET="81920"
FIRMWARE_SIZE="603715"
FIRMWARE_FILE="firmware.bin"
FIRMWARE_DIR="facetimehd"
FIRMWARE_MD5="4e1d11e205e5c55d128efa0029b268fe"

src_compile() {
	curl -s -L -r ${PKG_RANGE} ${PKG_URL} | xzcat -q |\
			cpio --format odc -i --to-stdout ${CAM_IF_PKG_PATH} > ${CAM_IF_FILE}
	echo "${CAM_IF_MD5} ${CAM_IF_FILE}" | md5sum -c || die "camera interface checksum mismatch"
	dd bs=1 skip=${FIRMWARE_OFFSET} count=${FIRMWARE_SIZE} if=${CAM_IF_FILE} |\
			gunzip > ${FIRMWARE_FILE}
	echo "${FIRMWARE_MD5} ${FIRMWARE_FILE}" | md5sum -c || die "firmware checksum mismatch"
}

src_install() {
	insinto "/lib/firmware/${FIRMWARE_DIR}"
	doins $FIRMWARE_FILE
}
