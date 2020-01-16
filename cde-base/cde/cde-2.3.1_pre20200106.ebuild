# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_COMMIT="1aaf63f2a01b8c78e9c9fbeda4ddefeb2c5afa68"
DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop (autotools version)"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI="https://sourceforge.net/code-snapshots/git/c/cd/cdesktopenv/code.git/cdesktopenv-code-${MY_COMMIT}.zip -> ${P}.zip"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X -doc l10n_en l10n_de l10n_it l10n_fr l10n_es l10n_ja"

DEPEND="
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXft
	x11-libs/libXpm
	x11-libs/libXaw
	x11-libs/motif
	media-libs/freetype
	dev-libs/openssl
	virtual/jpeg
"
RDEPEND="${DEPEND}
	x11-apps/xset
	x11-misc/xbitmaps
	net-libs/libtirpc
	"
BDEPEND="
	sys-devel/bison
	app-arch/ncompress
	x11-apps/bdftopcf
	app-shells/ksh
	"
PATCHES=(
	"${FILESDIR}"/${P}-Makefile_destinations.patch
	"${FILESDIR}"/${P}-disable_japanese.patch
)

S="${WORKDIR}"/cdesktopenv-code-${MY_COMMIT}/${PN}

src_prepare() {
	default
	sed -i -e "s#docsdir = \$(CDE_INSTALLATION_TOP)#docsdir = /usr/share/doc/${P}#" Makefile.am || die 'sed failed'
	eautoreconf
}

src_configure() {
	local my_econf
	econf \
		--docdir=/usr/share/doc/${P} \
		--bindir=/usr/dt/bin \
		--libdir=/usr/dt/lib \
		$(use_with X x) \
		$(use_enable l10n_de german) \
		$(use_enable l10n_it italian) \
		$(use_enable l10n_fr french) \
		$(use_enable l10n_es spanish) \
		$(use_enable l10n_ja japanese) \
		$my_econf

	eapply "${FILESDIR}"/${P}-link_libtrcp.patch
	#eapply "${FILESDIR}"/${P}-l10n_ja.patch
}

src_compile() {
	emake CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt
}

src_install() {
	dodir /etc/dt
	dodir /var/dt
	emake -j1 CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt DESTDIR="${D}" install

	# prepare editable system config:
	dodir /etc/dt/config
	insinto /etc/dt/config
	doins -r "${D}"/usr/dt/config/xfonts
	doins -r "${D}"/usr/dt/config/Xsession.d
	doins "${D}"/usr/dt/config/dtspcdenv
	doins "${D}"/usr/dt/config/sys.dtprofile
	doins "${D}"/usr/dt/config/Xaccess
	doins "${D}"/usr/dt/config/Xconfig
	doins "${D}"/usr/dt/config/Xfailsafe
	doins "${D}"/usr/dt/config/Xreset
	doins "${D}"/usr/dt/config/Xservers
	doins "${D}"/usr/dt/config/Xsetup
	doins "${D}"/usr/dt/config/Xstartup
	# fix paths:
	sed -e -i 's#/usr/config#/usr/dt/config#g' "${D}"/usr/dt/config/*

	# install X and other config things:
	dosym /usr/dt/bin/dtexec /usr/bin/dtexec
	insinto /usr/dt
	doins copyright
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/Xsession CDE
	into /usr/share/xsessions
	doins "${FILESDIR}"/CDE.desktop
	insinto /etc/xinetd.d
	doins contrib/xinetd/*
}
