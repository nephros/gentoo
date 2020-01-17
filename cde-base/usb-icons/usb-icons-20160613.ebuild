# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Icons for USB devices"
HOMEPAGE="http://myria.math.aegean.gr/~atsol/newpage-en/software/cde"
SRC_URI="http://myria.math.aegean.gr/~atsol/newpage-en/software/cde/files/usb-icons.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"/${PN}

src_compile() {
	:
}
src_install() {
	insinto /etc/dt/appconfig/icons/C/
	doins -r *
	default
}
