# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="The Common Desktop Environment"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI="mirror://sourceforge/cdesktopenv/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc64"
IUSE="xinetd"

DEPEND="
	media-libs/libjpeg-turbo
	media-libs/freetype
	media-fonts/font-adobe-100dpi
	media-fonts/font-adobe-utopia-100dpi
	media-fonts/font-bh-100dpi
	media-fonts/font-bh-lucidatypewriter-100dpi
	media-fonts/font-bitstream-100dpi
	net-nds/rpcbind
	x11-misc/xbitmaps
	app-shells/ksh
	net-libs/libtirpc
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXpm
	x11-libs/libXaw
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/motif
	virtual/awk
"

RDEPEND="${DEPEND}
	x11-apps/xset
"

BDEPEND="
	app-arch/ncompress
	dev-lang/tcl
	sys-devel/bison
	sys-devel/m4
	virtual/awk
"

PATCHES=( "${FILESDIR}/dtinfo-ppc.patch" )

pkg_pretend() {
	#TODO: handle non-unicode locales?
	localedef --list-archive | grep -sq en_US.utf8 || die \
			"${PN} requires en_US.UTF-8 locale to be available"
}

src_prepare() {
	default

	sed -i '/^CC =/ s/cc/$(shell printenv CC)/' config/imake/Makefile.ini || die

	sed -i \
		-e '/^#define CcCmd/ s/gcc.*/$(shell printenv CC)/' \
		-e '/^#define CplusplusCmd/ s/g++.*/$(shell printenv CXX) -fpermissive/' \
		-e '/^#define AsCmd/ s/as/$(shell printenv AS)/' \
		-e '/^#define LdCmd/ s/ld/$(shell printenv LD)/' \
		config/cf/linux.cf || die
}

src_configure() {
	# build system is pretty old (mid 199x) so we have to dance
	tc-export AS CC CPP CXX LD
	append-flags -fno-strict-aliasing -Wno-write-strings -Wno-deprecated-declarations

	# build system has a habit of not failing on errors, custom ShellFlags handle it.
	# also it supports some non unicode locales but we turn it off.
	# all locales have to be present in locale-archve prior to build
	cat <<- _EOF_ >> config/cf/site.def
		#define ExtraLoadFlags ${LDFLAGS}
		#define HasZlib YES
		#define LinuxDistribution LinuxGentoo
		#define DtLocalesToBuild en_US.UTF-8
		#define DtDocLocalesToBuild en_US.UTF-8
		#define MakeFlagsToShellFlags(makeflags,shellcmd) set -e
		#define OptimizedCDebugFlags ${CFLAGS}
	_EOF_
# TODO: LDFLAGS not honored:
# /usr/dt/lib/libDtHelp.so.2.1
# /usr/dt/lib/libDtMmdb.so.2.1
# /usr/dt/lib/libDtMrm.so.2.1
# /usr/dt/lib/libDtPrint.so.2.1
# /usr/dt/lib/libDtSearch.so.2.1
# /usr/dt/lib/libDtSvc.so.2.1
# /usr/dt/lib/libDtTerm.so.2.1
# /usr/dt/lib/libDtWidget.so.2.1
# /usr/dt/lib/libcsa.so.2.1
# /usr/dt/lib/libtt.so.2.1
}

src_compile() {
	IMAKECPP=cpp LANG=C LC_ALL=C emake World -j1 #nowarn
}

src_install() {
	INSTALL_LOCATION="${ED}/usr/dt" \
	LOGFILES_LOCATION="${ED}/var/dt" \
	CONFIGURE_LOCATION="${ED}/etc/dt" \
	./admin/IntegTools/dbTools/installCDE \
		-s "${S}" -destdir "${ED}/" -DontRunScripts || die

	insinto /usr/share/xsessions
	doins contrib/desktopentry/cde.desktop

	keepdir /var/dt
	keepdir /var/spool/calendar

	newenvd - 60cde <<-_EOF_
	LDPATH="${EPREFIX}/usr/dt/lib"
	MANPATH="${EPREFIX}/usr/dt/man"
	PATH="${EPREFIX}/usr/dt/bin"
	_EOF_

	if use xinetd ; then
		insinto /etc/xinetd.d
		doins contrib/xinetd/{cmsd,ttdbserver}
	fi
	# TODO: pam.d , dtlogin via xdm and systemd
}
