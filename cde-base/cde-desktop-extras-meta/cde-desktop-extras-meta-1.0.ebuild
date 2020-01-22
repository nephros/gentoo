# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for additional desktop programs used in CDE"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	www-client/dillo
	media-gfx/xv
	games-arcade/xbill[-gtk]
	media-sound/xmms2
	x11-misc/3dfm
	x11-misc/xfractint
"
RDEPEND="${DEPEND}"
BDEPEND=""
