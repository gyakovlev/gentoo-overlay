# Copyright 2017-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.4
ansi_term-0.10.2
ansi_term-0.9.0
atty-0.2.6
bitflags-0.7.0
bitflags-1.0.1
cfg-if-0.1.2
clap-2.29.0
crossbeam-0.2.10
ctrlc-3.0.3
diff-0.1.11
fnv-1.0.6
fuchsia-zircon-0.3.2
fuchsia-zircon-sys-0.3.2
globset-0.2.1
ignore-0.2.2
kernel32-sys-0.2.2
lazy_static-0.2.11
lazy_static-1.0.0
libc-0.2.34
log-0.3.9
log-0.4.1
memchr-1.0.2
memchr-2.0.1
nix-0.8.1
num_cpus-1.8.0
rand-0.3.19
redox_syscall-0.1.33
redox_termios-0.1.1
regex-0.2.5
regex-syntax-0.4.2
same-file-0.1.3
strsim-0.6.0
tempdir-0.3.5
term_size-0.3.1
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.5
unicode-width-0.1.4
unreachable-1.0.0
utf8-ranges-1.0.0
vec_map-0.8.0
version_check-0.1.3
void-1.0.2
walkdir-1.0.7
winapi-0.2.8
winapi-0.3.2
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.3.2
winapi-x86_64-pc-windows-gnu-0.3.2
"

inherit cargo

DESCRIPTION="fd is a simple, fast and user-friendly alternative to find."
HOMEPAGE="https://github.com/sharkdp/fd"
SRC_URI="https://github.com/sharkdp/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="|| ( MIT Apache-2.0 )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND=">=virtual/rust-1.20.0"
RDEPEND="${DEPEND}"

src_install() {
	cargo_src_install
	dodoc README.md
	doman doc/*.1
}

src_test() {
        cargo test -v
}