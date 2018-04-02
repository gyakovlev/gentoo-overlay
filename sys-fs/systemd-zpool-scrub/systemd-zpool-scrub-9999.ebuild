# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit systemd

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/lnicola/${PN}.git"
else
	die "no versioned ebuilds yet"
fi

DESCRIPTION="systemd zpool scrub service and timer "
HOMEPAGE="https://github.com/lnicola/systemd-zpool-scrub"

LICENSE="MIT"
SLOT="0"

DEPEND=""
RDEPEND="sys-fs/zfs"

src_prepare() {
	eapply_user
	sed -i s'#/usr/bin/zpool#/sbin/zpool#'g zpool-scrub@.service || die
}

src_install() {
	systemd_dounit zpool-scrub@.service
	systemd_dounit zpool-scrub@.timer
	einstalldocs
}

pkg_postinst() {
	elog "to enable periodic scrub, run:"
	elog "	systemctl enable --now zpool-scrub@poolname.timer"
	elog "for each pool you want to scrub weekly"
	elog
}
