# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jedisct1/${PN}"
MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"

inherit fcaps golang-build systemd user

DESCRIPTION="A flexible DNS proxy, with support for encrypted DNS protocols"
HOMEPAGE="https://github.com/jedisct1/dnscrypt-proxy"
SRC_URI="https://${EGO_PN}/archive/${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
RESTRICT="mirror"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="utils"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )

S="${WORKDIR}/${MY_P}"

pkg_setup() {
        enewgroup dnscrypt
        enewuser dnscrypt -1 -1 /var/empty dnscrypt
}

src_compile() {
	mkdir "src" || die
	mv "${PN}" "src/" || die
	mv "vendor" "src/" || die
	GOPATH="${S}" go build -x -v -ldflags="-s -w" "./src/${PN}" || die
}

src_install() {
	dobin dnscrypt-proxy
	sed -i "s:/opt/dnscrypt-proxy:/usr/bin:" "${S}/systemd/dnscrypt-proxy.service" || die
    systemd_dounit "${S}/systemd/dnscrypt-proxy.service"
    systemd_dounit "${S}/systemd/dnscrypt-proxy.socket"
}