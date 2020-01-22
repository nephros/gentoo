# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for additional X11 programs used in CDE"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv https://www.x.org/wiki/"
SRC_URI=""
LICENSE="metapackage"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-util/xxdiff
	x11-apps/oclock
	x11-apps/xbiff
	x11-apps/xclock
	x11-apps/xconsole
	x11-apps/xeyes
	x11-apps/xfontsel
	x11-apps/xhost
	x11-apps/xkill
	x11-apps/xload
	x11-apps/xlogo
	x11-apps/xlsfonts
	x11-misc/xosview
	x11-apps/xrdb
	x11-apps/xset
	x11-apps/xsetroot
	x11-apps/xvidtune
	x11-apps/xwud
	x11-misc/xcb[motif]
	x11-misc/xlockmore[motif]
"
RDEPEND="${DEPEND}"
BDEPEND=""
