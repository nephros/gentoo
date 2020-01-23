# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for additional desktop programs used in CDE"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI=""

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vi emacs calendar mozilla"
LICENSE="metapackage"

DEPEND="
	!vi? (
		!emacs? (
			app-editors/nedit
			)
		)
	cde-base/desktop-approots
	cde-base/usb-icons
	emacs? ( || ( app-editors/emacs:*[motif] app-editors/xemacs[motif] ) )
	media-gfx/xv
	media-sound/xmms2
	mozilla? ( || ( www-client/mozilla www-client/netscape-navigator www-client/netscape-navigator-bin www-client/seamonkey-bin www-client/seamonkey ) )
	vi? ( || ( app-editors/vim[X] app-editors/gvim[motif] app-editors/xvile ) )
	!mozilla? ( www-client/dillo )
	calendar? ( x11-misc/xcalendar[motif] )
"
RDEPEND="${DEPEND}"
BDEPEND=""
