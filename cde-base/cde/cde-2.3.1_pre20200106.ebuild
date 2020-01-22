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
IUSE="X -xinetd -doc l10n_en l10n_de l10n_it l10n_fr l10n_es l10n_ja examples"

DEPEND="
	x11-base/xorg-x11
	x11-libs/motif[jpeg,xft]
	media-libs/freetype
	dev-libs/openssl
"
RDEPEND="${DEPEND}
	xinetd? (
		sys-apps/xinetd
		net-nds/rpcbind
	)
	x11-misc/xbitmaps
	media-fonts/font-adobe-100dpi[X]
	media-fonts/font-adobe-75dpi[X]
	"
BDEPEND="
	sys-devel/bison
	net-libs/libtirpc
	app-arch/ncompress
	x11-apps/bdftopcf
	app-shells/ksh
	"
PATCHES=(
	"${FILESDIR}"/${PV}-Makefile_destinations.patch
	"${FILESDIR}"/${PV}-disable_japanese.patch
	"${FILESDIR}"/${PV}-XkbKeycodeToKeysym.patch
	"${FILESDIR}"/${PV}-build_additional.patch
	"${FILESDIR}"/${PV}-build_dthelpview.patch
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

	eapply "${FILESDIR}"/${PV}-link_libtrcp.patch
	#eapply "${FILESDIR}"/${PV}-l10n_ja.patch
}

src_compile() {
	emake CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt
}

src_install() {
	dodir /etc/dt
	dodir /var/dt
	emake -j1 CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt DESTDIR="${D}" install || die "install failed."
	einfo "emake install finished"
	# prepare editable system config:
	dodir /etc/dt/config
	insinto /etc/dt/config
	doins -r "${D}"/usr/dt/config/xfonts
	doins -r "${D}"/usr/dt/config/Xsession.d
	local dtcfg
	dtcfg="dtspcdenv sys.dtprofile Xaccess Xconfig Xfailsafe Xreset Xservers Xsetup Xstartup"
	for f in $dtcfg; do
		einfo "installing /usr/dt/config/${f}"
		# fix paths, /usr/config we don't have:
		sed -i -e 's#/usr/config#/usr/dt/config#g' "${D}"/usr/dt/config/${f} || die "sed failed"
		doins "${D}"/usr/dt/config/${f}
	done

	# install X and other config things:
	dosym /usr/dt/bin/dtexec /usr/bin/dtexec
	insinto /usr/dt
	doins copyright
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/Xsession CDE
	into /usr/share/xsessions
	doins "${FILESDIR}"/CDE.desktop
	if use examples; then
		dodc -r examples
	fi
	if use xinetd; then
		insinto /etc/xinetd.d
		doins contrib/xinetd/*
	fi
}

pkg_postinst() {
	if use xinetd; then
		/sbin/rc-service xinetd --ifstarted reload
		ewarn 'NOTE: You have enabled the xinetd USE flag.'
		ewarn 'Two new RPC services, cmsd and ttdbserver'
		ewarn 'have been installed, and ttdbserver is set to "enabled".'
		ewarn ''
		ewarn 'running these services is normally not required, and may pose a security risk.'
	fi
}
