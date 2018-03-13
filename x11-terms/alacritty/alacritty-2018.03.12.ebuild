# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.4
android_glue-0.2.3
ansi_term-0.10.2
approx-0.1.1
arraydeque-0.4.2
atty-0.2.6
base64-0.9.0
bitflags-0.4.0
bitflags-0.7.0
bitflags-0.8.2
bitflags-0.9.1
bitflags-1.0.1
block-0.1.6
byteorder-1.2.1
bytes-0.3.0
cargo_metadata-0.2.3
cc-1.0.5
cfg-if-0.1.2
cgl-0.2.1
cgmath-0.16.0
clap-2.30.0
clippy-0.0.187
clippy_lints-0.0.187
cmake-0.1.29
cocoa-0.14.0
copypasta-0.0.1
core-foundation-0.5.1
core-foundation-sys-0.5.1
core-graphics-0.13.0
core-text-9.2.0
dlib-0.4.0
dtoa-0.4.2
either-1.4.0
env_logger-0.5.4
errno-0.2.3
euclid-0.17.1
expat-sys-2.1.5
filetime-0.1.15
fnv-1.0.6
font-0.1.0
foreign-types-0.3.2
foreign-types-shared-0.1.1
freetype-rs-0.13.0
freetype-sys-0.4.0
fsevent-0.2.17
fsevent-sys-0.1.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
getopts-0.2.17
gl_generator-0.9.0
gleam-0.4.23
glutin-0.13.0
humantime-1.1.1
idna-0.1.4
if_chain-0.1.2
inotify-0.3.0
iovec-0.1.2
itertools-0.6.5
itoa-0.3.4
kernel32-sys-0.2.2
khronos_api-2.1.0
lazy_static-1.0.0
lazycell-0.4.0
lazycell-0.6.0
libc-0.2.37
libloading-0.4.3
libz-sys-1.0.18
linked-hash-map-0.5.1
log-0.3.9
log-0.4.1
malloc_buf-0.0.6
matches-0.1.6
memchr-2.0.1
memmap-0.6.2
mio-0.5.1
mio-0.6.13
mio-more-0.1.0
miow-0.1.5
miow-0.2.1
net2-0.2.32
nix-0.5.1
notify-4.0.3
num-traits-0.1.43
num-traits-0.2.1
objc-0.2.2
objc-foundation-0.1.1
objc_id-0.1.0
osmesa-sys-0.1.2
owning_ref-0.3.3
parking_lot-0.5.4
parking_lot_core-0.2.13
percent-encoding-1.0.1
pkg-config-0.3.9
pulldown-cmark-0.0.15
quick-error-1.2.1
quine-mc_cluskey-0.2.4
quote-0.3.15
rand-0.3.22
rand-0.4.2
redox_syscall-0.1.37
redox_termios-0.1.1
regex-0.2.6
regex-syntax-0.4.2
safemem-0.2.0
same-file-1.0.2
semver-0.6.0
semver-parser-0.7.0
serde-1.0.27
serde_derive-1.0.27
serde_derive_internals-0.19.0
serde_json-1.0.10
serde_yaml-0.7.3
servo-fontconfig-0.4.0
servo-fontconfig-sys-4.0.3
shared_library-0.1.8
slab-0.1.3
slab-0.3.0
smallvec-0.6.0
stable_deref_trait-1.0.0
strsim-0.7.0
syn-0.11.11
synom-0.11.3
tempfile-2.2.0
termcolor-0.3.5
termion-1.5.1
textwrap-0.9.0
thread_local-0.3.5
time-0.1.39
token_store-0.1.2
toml-0.4.5
unicode-bidi-0.3.4
unicode-normalization-0.1.5
unicode-width-0.1.4
unicode-xid-0.0.4
unreachable-1.0.0
url-1.7.0
utf8-ranges-1.0.0
utf8parse-0.1.0
vcpkg-0.2.2
vec_map-0.8.0
void-1.0.2
vte-0.3.2
walkdir-2.1.4
wayland-client-0.12.5
wayland-kbd-0.13.1
wayland-protocols-0.12.5
wayland-scanner-0.12.5
wayland-sys-0.12.5
wayland-window-0.13.2
winapi-0.2.8
winapi-0.3.4
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
wincolor-0.1.6
winit-0.11.1
ws2_32-sys-0.2.1
x11-dl-2.17.3
xdg-2.1.0
xml-rs-0.7.0
yaml-rust-0.4.0
"

inherit eutils cargo git-r3

DESCRIPTION="GPU-accelerated terminal emulator "
HOMEPAGE="https://github.com/jwilm/alacritty"
SRC_URI="$(cargo_crate_uris ${CRATES})"
EGIT_REPO_URI="https://github.com/jwilm/${PN}"

if [[ $PV == 9999 ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64"
	EGIT_COMMIT_DATE="${PV}"
fi

RESTRICT="mirror"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

RDEPEND="
	media-libs/freetype:2=
	media-libs/fontconfig
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	x11-libs/libXi
	media-libs/mesa
	x11-misc/xclip
"
DEPEND="${RDEPEND}
	dev-util/cmake
	virtual/pkgconfig
"
src_unpack() {
	git-r3_src_unpack
	cargo_src_unpack
}

src_compile() {
	cargo_gen_config
	cargo build -v -j $(makeopts_jobs) $(usex debug "" --release) \
		|| die "cargo build failed"
}
src_install() {
	cargo_src_install

	domenu Alacritty.desktop
	insinto /usr/share/alacritty
	doins alacritty.yml

	dodir /usr/share/terminfo/a
	tic -o "${ED}/usr/share/terminfo" alacritty.info
}