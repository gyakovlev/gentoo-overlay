# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/electrified/${PN}.git"
else
	EGIT_COMMIT="1ed9fc665514ef6b30c00739f85fa8e4521e324b"
	SRC_URI="https://github.com/electrified/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="ASUS WMI Sensor driver"
HOMEPAGE="https://github.com/electrified/asus-wmi-sensors"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

CONFIG_CHECK="ACPI_WMI HWMON"
MODULE_NAMES="asus-wmi-sensors"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="TARGET=${KV_FULL} KERNEL_BUILD=${KERNEL_DIR} KBUILD_VERBOSE=1"
}

src_install() {
	linux-mod_src_install

	echo "${PN}" > "${T}/${PN}".conf || die
	insinto /usr/lib/modules-load.d/
	doins "${T}/${PN}".conf
	einstalldocs
}
