# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PV=${PV/_beta/b}
DESCRIPTION=""
HOMEPAGE="https://ftp.mozilla.org/pub/mozilla"
SRC_URI="https://ftp.mozilla.org/pub/mozilla/releases/${PN}${MY_PV}/mozilla-i686-pc-linux-gnu-gtk2%2bxft-${MY_PV}.tar.gz"

LICENSE="MPL-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x11-libs/pangox-compat[abi_x86_32]
	amd64? ( sys-libs/libstdc++-v3[multilib] )
	x86? ( sys-libs/libstdc++-v3 )
	"
BDEPEND=""

S="${WORKDIR}"/${PN}

src_install() {
	dodoc README.txt
	dodir /opt/${PN}
	cp -r * ${D}/opt/${PN}/ || die "install failed"
	domenu "${FILESDIR}"/${PN}.desktop
	dosym /opt/${PN}/mozilla /usr/bin/mozilla
	dosym /opt/${PN}/mozilla /opt/bin/mozilla
}
