# Copyright 1999-2018 Gentoo Foundation
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
#IUSE="utils"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )

S="${WORKDIR}/${MY_P}"

#pkg_setup() {
#		enewgroup dnscrypt
#		enewuser dnscrypt -1 -1 /var/empty dnscrypt
#}

src_prepare() {
	default

	cd "${S}/${PN}" || die
	sed -i 's|\['\''127\.0\.0\.1:53'\'', '\''\[::1\]:53'\''\]|\[\]|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''dnscrypt-proxy\.log'\''|'\''/var/log/dnscrypt-proxy/dnscrypt-proxy\.log'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''forwarding-rules\.txt'\''|'\''/etc/dnscrypt-proxy/forwarding-rules\.txt'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''cloaking-rules\.txt'\''|'\''/etc/dnscrypt-proxy/cloaking-rules\.txt'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''query\.log'\''|'\''/var/log/dnscrypt-proxy/query\.log'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''nx\.log'\''|'\''/var/log/dnscrypt-proxy/nx\.log'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''blacklist\.txt'\''|'\''/etc/dnscrypt-proxy/blacklist\.txt'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''blocked\.log'\''|'\''/var/log/dnscrypt-proxy/blocked\.log'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''ip-blacklist\.txt'\''|'\''/etc/dnscrypt-proxy/ip-blacklist\.txt'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''ip-blocked\.log'\''|'\''/var/log/dnscrypt-proxy/ip-blocked\.log'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''public-resolvers\.md'\''|'\''/var/cache/dnscrypt-proxy/public-resolvers\.md'\''|g' example-dnscrypt-proxy.toml || die
	sed -i 's|'\''parental-control\.md'\''|'\''/var/cache/dnscrypt-proxy/parental-control\.md'\''|g' example-dnscrypt-proxy.toml || die
}

src_compile() {
	mkdir "src" || die
	mv "${PN}" "src/" || die
	mv "vendor" "src/" || die
	GOPATH="${S}" go build -x -v -ldflags="-s -w" "./src/${PN}" || die
}

src_install() {
	default

	dobin dnscrypt-proxy
	insinto /etc/${PN}
	newins "${S}/src/${PN}"/example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	doins "${S}/src/${PN}"/example-{blacklist.txt,cloaking-rules.txt,forwarding-rules.txt}

	sed -i "s:/opt/dnscrypt-proxy/dnscrypt-proxy:${EROOT}usr/bin/dnscrypt-proxy --config /etc/dnscrypt-proxy/dnscrypt-proxy.toml:" \
		"${S}/systemd/dnscrypt-proxy.service" || die

	systemd_dounit "${S}/systemd/dnscrypt-proxy.service"
	systemd_dounit "${S}/systemd/dnscrypt-proxy.socket"

	keepdir /var/log/${PN}
}
