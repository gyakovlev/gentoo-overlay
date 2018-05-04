# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/zfsonlinux/${PN}.git"
else
	SRC_URI="https://github.com/zfsonlinux/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-upstream-${PV}"
fi

DESCRIPTION="ZFS Automatic Snapshot Service for Linux"
HOMEPAGE="https://github.com/zfsonlinux/zfs-auto-snapshot"

LICENSE="GPL-2"
SLOT="0"
IUSE="+default-exclude"

RDEPEND="sys-fs/zfs
		virtual/cron"

src_install() {
	if use default-exclude; then
		for cronfile in etc/${PN}.cron.{daily,hourly,monthly,weekly}; do
			sed -i "s/\(^exec ${PN}\)/\1 --default-exclude/" "$cronfile" || die
		done
		sed -i "s/\(; ${PN}\)/\1 --default-exclude/" etc/"${PN}".cron.frequent
	fi
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install
}

pkg_postinst() {
	if ! use default-exclude; then
		ewarn "snapshots are enabled by default for ALL zfs filesystems"
		ewarn "set com.sun:auto-snapshot=false or enable 'default-exclude' flag"
		elog
	fi
	elog "use com.sun:auto-snapshot attribute to enable snapshots for datasets"
	elog "the syntax is:"
	elog
	elog "zfs set com.sun:auto-snapshot=[true|false]"
	elog "or"
	elog "zfs set com.sun:auto-snapshot:<frequent|hourly|daily|weekly|monthly>=[true|false]"
	elog
	elog "for example:"
	elog "# zfs set com.sun:auto-snapshot=false zroot"
	elog "# zfs set com.sun:auto-snapshot=true zroot/ROOT/default"
	elog "# zfs set com.sun:auto-snapshot:weekly=true pool/var"
	elog
	elog "for detail please visit:"
	elog "https://docs.oracle.com/cd/E19120-01/open.solaris/817-2271/ghzuk/index.html"
	elog

	if has_version sys-process/fcron; then
		ewarn "frequent snapshot may not work if you are using fcron"
		ewarn "you should add frequent job to crontab manually"
	fi
}
