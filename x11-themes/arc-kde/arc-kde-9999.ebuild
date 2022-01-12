# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 optfeature


DESCRIPTION="Arc KDE customization"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/arc-kde"
EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/${PN}.git"

LICENSE="GPL-3+ wallpapers? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS=""

MY_THEMES=( +aurorae +color-schemes +konsole konversation +kvantum +plasma +wallpapers +yakuake )

IUSE="${MY_THEMES[@]}"
REQUIRED_USE="|| ( ${MY_THEMES[@]/#+} )"

RDEPEND="kvantum? ( x11-themes/kvantum )"

src_compile() { : ; }

src_install() {
	local themes=( ${MY_THEMES[@]#+} )
	local v variants=(
		$(for v in ${themes[@]}; do
			case ${v} in
				kvantum)
					usev ${v} ${v^}
					;;
				*)
					usev ${v}
					;;
			esac
		done)
	)

	emake DESTDIR="${ED}" THEMES="${variants[*]}" install
	einstalldocs
}

pkg_postinst() {
	optfeature "matching theme for GTK apps" x11-themes/arc-theme
}
