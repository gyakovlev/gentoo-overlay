# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EGO_PN="github.com/evilsocket/opensnitch"
EGO_VENDOR=(
	"github.com/evilsocket/opensnitch f71d8ce52f79db97f66782c37a2e6506b96e02ad"
	"github.com/evilsocket/ftrace 06529699d3b47fd1adae671b6851dd6f7539c841"
	"github.com/fsnotify/fsnotify c2828203cd70a50dcccfb2761f8b1f8ceef9a8e9"
	"github.com/golang/protobuf 925541529c1fa6821df4e44ce2723319eb2be768"
	"github.com/google/gopacket 11c65f1ca9081dfea43b4f9643f5c155583b73ba"
	"golang.org/x/net 8d16fa6dc9a85c1cd3ed24ad08ff21cf94f10888 github.com/golang/net"
	"golang.org/x/sys b126b21c05a91c856b027c16779c12e3bf236954 github.com/golang/sys"
	"golang.org/x/text f21a4dfb5e38f5895301dc265a8def02365cc3d0 github.com/golang/text"
	"google.golang.org/genproto 7fd901a49ba6a7f87732eb344f6e3c5b19d1b200 github.com/google/go-genproto"
	"google.golang.org/grpc d11072e7ca9811b1100b80ca0269ac831f06d024 github.com/grpc/grpc-go"
	)
inherit golang-build golang-vcs-snapshot systemd

DESCRIPTION="Linux port of the Little Snitch application firewall (daemon)"
HOMEPAGE="https://www.opensnitch.io"
SRC_URI="${EGO_VENDOR_URI}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/protobuf
	net-libs/libpcap
	net-libs/libnetfilter_queue"
RDEPEND="${DEPEND}"

RESTRICT="test" # does some sudo pip installs

src_compile() {
	pushd src/${EGO_PN}/daemon || die
		GOPATH="${S}" go build -o opensnitchd . || die
	popd || die
}

src_install() {
	pushd src/${EGO_PN}/daemon || die
	dobin opensnitchd
	systemd_dounit opensnitchd.service
	keepdir /etc/opensnitchd/rules
}
