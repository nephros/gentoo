# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta Package to install all CDE packages"
HOMEPAGE="https://sourceforge.net/p/cdesktopenv/wiki/Home/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="cde-base/cde
	cde-base/desktop-approots
	cde-base/usb-icons"
RDEPEND="${DEPEND}"
BDEPEND=""
