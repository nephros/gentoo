# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools font

MY_COMMIT="1aaf63f2a01b8c78e9c9fbeda4ddefeb2c5afa68"
DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop (autotools version)"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI="https://sourceforge.net/code-snapshots/git/c/cd/cdesktopenv/code.git/cdesktopenv-code-${MY_COMMIT}.zip -> ${P}.zip
	https://raw.githubusercontent.com/dcantrell/cderpm/master/fonts.alias -> ${P}_fonts.alias"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X -xinetd -doc tools l10n_en l10n_de l10n_it l10n_fr l10n_es l10n_ja examples"

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
	"${FILESDIR}"/CVE-2020-2696_VU_308289_6b3224.diff
	"${FILESDIR}"/${PV}-Makefile_destinations.patch
	"${FILESDIR}"/${PV}-disable_japanese.patch
	"${FILESDIR}"/${PV}-XkbKeycodeToKeysym.patch
	"${FILESDIR}"/${PV}-build_additional_programs.patch
	"${FILESDIR}"/${PV}-build_dthelpview.patch
	"${FILESDIR}"/${PV}-build_dtinfo.patch
	"${FILESDIR}"/${PV}-build_nsgmls.patch
)

S="${WORKDIR}"/cdesktopenv-code-${MY_COMMIT}/${PN}

FONTDIR=/usr/share/fonts/cde
FONT_PN=dtinfo
FONT_S="${S}"/programs/fontaliases/linux/C
FONT_SUFFIX=pcf.gz

pkg_pretend() {
	if use xinetd; then
		ewarn ''
		ewarn 'BIG FAT WARNING: You have enabled the xinetd USE flag.'
		ewarn 'This will install CDE RPC services (cmsd and ttdbserver)'
		ewarn ''
		ewarn 'Running these services may pose a security risk, and is normally not required.'
		ewarn 'See the Security section in the Wiki: https://sourceforge.net/p/cdesktopenv/wiki/Home/'
		ewarn ''
		ewarn 'Unset the xinetd USE flag for this package to get rid of this warning.'
		ewarn ''
		if [[ "x${GIVE_ME_INSECURE_RPC}" = "x" ]]; then
			ewarn 'If you really want this, set the GIVE_ME_INSECURE_RPC variable to any value and restart the emerge.'
			die 'Insecure installation prevented. See the warnings above.'
		fi
	fi
}

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
	keepdir /etc/dt
	dodir /var/dt
	dodir /var/spool/calendar
	keepdir /var/spool/calendar
	emake -j1 CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt DESTDIR="${D}" install || die "install failed."
	einfo "emake install finished"

	einfo "installing fonts at ${FONTDIR}"
	# font_src_install # this fails becaue of nonexistant DOCS which we "always install" ;)
	# stuff copied from font.eclass here:
	pushd "${FONT_S}" > /dev/null
	insinto "${FONTDIR}"
	for suffix in ${FONT_SUFFIX}; do
		doins *.${suffix}
	done
		font_xfont_config
		popd > /dev/null
	font_fontconfig
	einfo "font install finished"

	einfo "preparing editable system config in /etc/dt"
	dodir /etc/dt/config
	insinto /etc/dt/config
	doins -r "${D}"/usr/dt/config/xfonts
	# try the fixed fonts from others
	#for fa in $(find ${D}/etc/dt/config -name fonts.alias ); do
	#	cp "${DISTDIR}"/${P}_fonts.alias "${fa}"
	#done
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
	doins copyright # needed by dtgreeter splash
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/Xsession CDE
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/CDE.desktop
	if use doc; then
		einfo "This ebuild does not support CDE Style documentation or man pages yet."
		einfo "But you can browse the included guides in PDF format in ${DOCDIR}"
		dodoc doc/C/pdf/*
	fi
	if use examples; then
		dodoc -r examples
	fi
	if use tools; then
		dobin "${FILESDIR}"/desktop2dt.sh
		cp "${S}"/contrib/vcal2xapia/vcal2xapia.awk "${S}"/contrib/vcal2xapia/vcal2xapia
		for tool in desktop2dt vcal2xapia; do
			dodir /usr/dt/bin/tools/${tool}
			insinto /usr/dt/bin/tools/${tool}
			doins contrib/${tool}/README
			exeinto /usr/dt/bin/tools/${tool}
			doexe contrib/${tool}/${tool}
		done
	fi
	if use xinetd; then
		insinto /etc/xinetd.d
		doins contrib/xinetd/*
	fi
}

pkg_postinst() {
	einfo ''
	einfo 'In order to get prettier fonts via Xft, add the following to your ~/.Xresources file:'
	einfo '    *.renderTable: variable'
	einfo '    *.renderTable.variable.fontName: Sans'
	einfo '    *.renderTable.variable.fontSize: 8'
	einfo '    *.renderTable.variable.fontType: FONT_IS_XFT'
	einfo ''

	if use tools; then
		einfo ''
		einfo 'You can use the script named desktop2dt.sh to convert existing .desktop files to something CDE can use.'
		einfo ''
	fi

	if use xinetd; then
		if [[ ! "x${GIVE_ME_INSECURE_RPC}" = "x" ]]; then
			ewarn ''
			ewarn 'You have chosen to ignore the security concerns, and so'
			ewarn 'two new RPC services, cmsd and ttdbserver, have been installed to /etc/xinetd.d.'
			ewarn 'ttdbserver is set to "enabled".'
			ewarn ''
			ewarn 'Restart xinetd for the changes to take effect'
			ewarn ''
			ewarn 'Reminder: Running these services is normally not required.'
			ewarn 'See the Security section in the Wiki: https://sourceforge.net/p/cdesktopenv/wiki/Home/'
			ewarn ''
		fi
	fi
}
