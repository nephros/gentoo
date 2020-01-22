# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for games and amusmements for CDE"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="metapackage"

RDEPEND="${DEPEND}
	games-action/battalion
	games-simulation/micropolis
	games-arcade/xbill[-gtk]
	games-arcade/xlennart[-gtk,motif]
	x11-misc/3dfb
	x11-misc/3dfm
	games-arcade/xgalaga
	games-board/xboard[-gtk]
	x11-misc/xaos[X]
	x11-misc/xfractint
"
