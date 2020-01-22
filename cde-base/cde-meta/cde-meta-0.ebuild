# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta Package to install all CDE packages"
HOMEPAGE="https://sourceforge.net/p/cdesktopenv/wiki/Home/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="desktop +extras games heirloom-tools"

DEPEND="cde-base/cde
	extras? ( cde-base/cde-x11-extras-meta )
	desktop? (
		cde-base/cde-desktop-extras-meta
	)
	games? (
		cde-base/cde-games-meta
	)
	heirloom-tools? (
		sys-apps/heirloom-tools
		)
"
