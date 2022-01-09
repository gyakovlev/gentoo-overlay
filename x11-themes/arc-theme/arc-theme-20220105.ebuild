# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit meson python-any-r1

DESCRIPTION="A flat theme with transparent elements for GTK 2/3/4 and GNOME Shell"
HOMEPAGE="https://github.com/jnsh/arc-theme"
SRC_URI="https://github.com/jnsh/${PN}/releases/download/${PV}/arc-theme-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="cinnamon gnome-shell +gtk2 +gtk3 +gtk4 mate +transparency xfce"

SASSC_DEPEND="
	dev-lang/sassc
"

# Supports various GTK+3, GNOME Shell, and Cinnamon versions and uses
# pkg-config to determine which set of files to build. Updates will
# therefore break existing installs but there's no way around this. At
# least GTK+3 is unlikely to see a release beyond 3.24.
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/meson-0.56.0
	dev-libs/glib
	cinnamon? (
		${SASSC_DEPEND}
		gnome-extra/cinnamon
	)
	gnome-shell? (
		${SASSC_DEPEND}
		>=gnome-base/gnome-shell-3.28
	)
	gtk3? (
		${SASSC_DEPEND}
		virtual/pkgconfig
		=x11-libs/gtk+-3.24*:3
	)
	gtk4? (
		${SASSC_DEPEND}
		gui-libs/gtk:4
	)
"

# gnome-themes-standard is only needed by GTK+2 for the Adwaita
# engine. This engine is built into GTK+3.
RDEPEND="
	gtk2? (
		x11-themes/gnome-themes-standard
		x11-themes/gtk-engines-murrine
	)
"

src_configure() {
	local themes=$(
		printf "%s," \
		$(usev cinnamon) \
		$(usev gnome-shell) \
		$(usev gtk2) \
		$(usev gtk3) \
		$(usev gtk4) \
		$(usex mate metacity "") \
		$(usex xfce xfwm "")
	)

	local emesonargs=(
		-Dthemes="${themes%,}"
		$(meson_use gnome-shell gnome_shell_gresource)
		$(meson_use transparency)
	)

	meson_src_configure
}
