# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Integrates a couple of modern applications into CDE"
HOMEPAGE="http://myria.math.aegean.gr/~atsol/newpage-en/software/cde"
SRC_URI="http://myria.math.aegean.gr/~atsol/newpage-en/software/cde/files/desktop_approots.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"/desktop_approots

src_compile() {
	:
}

src_install() {
	insinto /etc/desktop_approots
	doins -r *
}

pkg_postinst() {
	einfo "You will have to go to /etc/desktop_approots and run"
	einfo "the integrate_all_apps.sh script as root to complete installation."i
}
