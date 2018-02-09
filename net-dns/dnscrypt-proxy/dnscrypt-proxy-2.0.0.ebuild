# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/jedisct1/${PN}"

inherit fcaps golang-build systemd user

DESCRIPTION="A flexible DNS proxy, with support for encrypted DNS protocols"
HOMEPAGE="https://github.com/jedisct1/dnscrypt-proxy"
if [[ "${PV}" = 9999* ]] ; then
	inherit golang-vcs
else
	SRC_URI="https://${EGO_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="ISC"
SLOT="0"

FILECAPS=( cap_net_bind_service+ep usr/bin/dnscrypt-proxy )

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
	# Create directory structure suitable for building
	mkdir -p "src/${EGO_PN}" || die
	rm -r "src/${EGO_PN}" || die
	mv "${PN}" "src/${EGO_PN}" || die
	mv "vendor" "src/" || die
	golang-build_src_compile
}

src_install() {
	default

	dobin dnscrypt-proxy

	insinto /etc/${PN}
	newins "src/${EGO_PN}"/example-dnscrypt-proxy.toml dnscrypt-proxy.toml
	doins "src/${EGO_PN}"/example-{blacklist.txt,cloaking-rules.txt,forwarding-rules.txt}

	insinto "/usr/share/${PN}"
	doins -r "utils/generate-domains-blacklists/"

	sed -i -e "/^ExecStart=/ s|=/opt/dnscrypt-proxy/dnscrypt-proxy|=${EROOT}usr/bin/dnscrypt-proxy|" \
		systemd/dnscrypt-proxy.service || die "sed failed"
	sed -i -e "/^ExecStart=/ s|$|  --config ${EROOT}etc/dnscrypt-proxy/dnscrypt-proxy.toml|" \
		systemd/dnscrypt-proxy.service || die "sed failed"

	newinitd "${FILESDIR}"/${PN}.initd-r2 ${PN}
    newconfd "${FILESDIR}"/${PN}.confd-r2 ${PN}
	systemd_dounit systemd/dnscrypt-proxy.service
	systemd_dounit systemd/dnscrypt-proxy.socket

	# TODO: move cache to initscript
	keepdir /var/cache/${PN}
	keepdir /var/log/${PN}
}
