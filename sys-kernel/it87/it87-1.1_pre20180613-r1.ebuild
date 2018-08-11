# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit linux-mod

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com//gyakovlev/${PN}.git"
else
	EGIT_COMMIT="bfbaf881f5bc1462b51e1b0296dba70d0b150515"
	SRC_URI="https://github.com/gyakovlev/it87/archive/${EGIT_COMMIT}.tar.gz -> ${PN}-${EGIT_COMMIT}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
fi

DESCRIPTION="Linux Driver for ITE LPC chips"
HOMEPAGE="https://github.com/gyakovlev/it87"

LICENSE="GPL-2+"
SLOT="0"
IUSE="doc"

CONFIG_CHECK="HWMON !CONFIG_SENSORS_IT87"
MODULE_NAMES="it87(kernel/drivers/hwmon:${S})"
BUILD_TARGETS="modules"

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="TARGET=${KV_FULL} KERNEL_BUILD=${KERNEL_DIR} KBUILD_VERBOSE=1"
}

src_install() {
	linux-mod_src_install

	echo it87 > "${T}"/it87.conf || die
	insinto /usr/lib/modules-load.d/
	doins "${T}"/it87.conf

	use doc && local DOCS=( ITE_Register_map.{csv,pdf} ISSUES README )
	einstalldocs
}
