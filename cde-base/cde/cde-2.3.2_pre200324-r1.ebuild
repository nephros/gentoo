# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_COMMIT="b64d91d5a942b0b7fcf9b94a38b362389e3c9294"
MY_PV=$(ver_cut 0-3)
DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop (autotools version)"
HOMEPAGE="https://sourceforge.net/projects/cdesktopenv"
SRC_URI="https://sourceforge.net/code-snapshots/git/c/cd/cdesktopenv/code.git/cdesktopenv-code-${MY_COMMIT}.zip -> ${PN}-${MY_PV}_${MY_COMMIT}.zip"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X -xinetd -doc tools l10n_en l10n_de l10n_it l10n_fr l10n_es l10n_ja examples system_sgml"

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
	system_sgml? ( app-text/opensp )
	"
PATCHES=(
	"${FILESDIR}"/${MY_PV}-disable_japanese.patch
)

S="${WORKDIR}"/cdesktopenv-code-${MY_COMMIT}/${PN}

pkg_pretend() {
	# this should really go into a pkg_nofetch() block, however the download actually does work, so lets keep this here:
	einfo ''
	einfo "NOTE: In case the download fails, please go to https://sourceforge.net/p/cdesktopenv/code/ci/${MY_COMMIT}/tree/"
	einfo 'and click the "Download Snapshot" link. Then run emerge again.'
	einfo 'You dont have to actually download the zip, but this makes the download URL available for portage to fetch..'
	einfo ''
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
	ewarn "You need to have locales generated for each of the supported languages."
	ewarn "Check /etc/locale.gen to include:"
	ewarn "	it_IT.UTF-8 UTF-8"
	ewarn "	es_ES.UTF-8 UTF-8"
	ewarn "	fr_FR.UTF-8 UTF-8"
	ewarn "and run locale-gen to prepare them."
	ewarn "You can remove those lines again after compilation."
}

src_unpack() {
	use system_sgml && PATCHES+=( "${FILESDIR}"/${MY_PV}-unbuild_nsgmls.patch )
	default
	if use doc; then
		mkdir "${WORKDIR}"/doc-generated
		pushd "${WORKDIR}"/doc-generated 2>/dev/null || die "pushd failed."
		unpack "${FILESDIR}"/man_generated.tar.xz
		unpack "${FILESDIR}"/help_generated.tar.xz
		popd
	fi
}
src_prepare() {
	sed -i -e "s#\[2.3.1\], [jon@radscan.com])#\[${PVR}_${MY_COMMIT}\], [gentoo@nephros.org])#" configure.ac || die 'sed failed'
	default
	sed -i -e "s#docsdir = \$(CDE_INSTALLATION_TOP)#docsdir = /usr/share/doc/${P}#" Makefile.am || die 'sed failed'
	eautoreconf
	use system_sgml && rm -r programs/nsgmls
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

}

src_compile() {
	# keep the _TOP variables defined in case of unclean source files:
	emake CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt
}

src_install() {
	keepdir /etc/dt
	dodir /etc/dt/config
	dodir /etc/dt/config/Xsession.d
	dodir /etc/dt/appconfig
	dodir /etc/dt/app-defaults
	keepdir /var/dt
	dosym /var/tmp/ /var/dt/tmp
	keepdir /var/spool/calendar
	# keep the _TOP variables defined in case of unclean source files:
	#emake -j1 CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt DESTDIR="${D}" install || die "install failed."
	emake CDE_INSTALLATION_TOP=/usr/dt CDE_CONFIGURATION_TOP=/etc/dt DESTDIR="${D}" install || die "install failed."

	# fix paths, /usr/config we don't have:
	for f in dtspcdenv sys.dtprofile Xaccess Xconfig Xfailsafe Xreset Xservers Xsetup Xstartup; do
		sed -i -e 's#/usr/config#/usr/dt/config#g' "${D}"/usr/dt/config/${f} || die "sed failed"
	done
	# Some eyecandy and custmizations:
	dodoc "${FILESDIR}"/README_Gentoo.md
	exeinto /etc/dt/config/Xsession.d
	doexe "${FILESDIR}"/0010.dtpaths
	insinto /etc/dt/backdrops
	doins "${FILESDIR}"/*.pm
	# install X.org and other system config things:
	dosym /usr/dt/bin/dtexec /usr/bin/dtexec
	insinto /usr/dt
	newbin "${FILESDIR}"/startcde.sh startcde
	newbin "${FILESDIR}"/startcde_windowed.sh startcde_windowed
	doins copyright # needed by dtgreeter splash
	exeinto /etc/X11/Sessions
	newexe "${FILESDIR}"/Xsession CDE
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/CDE.desktop
	if use doc; then
		dodoc doc/C/pdf/*
		pushd "${WORKDIR}"/doc-generated 2>/dev/null || die "pushd failed"
		rm man/man1/ksh.1	# file collision with app-shells/ksh
		# convert from SYSV to BSD Conventions:
		# 1 -> 1	General commands
		# 1m -> 8	System administration commands and daemons
		# 3 -> 3	library functions
		# 4 -> 5	File formats and conventions
		# 5 -> 7	Miscellanea
		# 6 -> 6	Games and screensavers
		mv man/man1m man/man8
		for f in man/man8/*.1m; do mv ${f} ${f%%.*}.8; done
		mv man/man5 man/man7
		for f in man/man7/*.5; do mv ${f} ${f%%.*}.7; done
		mv man/man4 man/man5
		for f in man/man5/*.4; do mv ${f} ${f%%.*}.5; done
		for d in man{1,3,{5..8}}; do
			for f in man/${d}/*; do
				einfo installing $f
				doman ${f}
			done
		done
		dodir /usr/dt/appconfig/help
		dodir /usr/dt/appconfig/help/C
		insinto /usr/dt/appconfig/help/C
		doins help-sdl/*
		rm help/Makefile
		rm help/Imakefile
		doins -r help/*
		popd
	fi
	if use examples; then
		dodoc -r examples
	fi
	if use system_sgml; then
		rm "${D}"/usr/dt/bin/nsgmls
		dosym /usr/bin/onsgmls /usr/dt/bin/nsgmls
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
	einfo 'There are several known issues with the current ebuild.'
	einfo "You are encouraged to read ${DOCDIR}/README_Gentoo.md about them."
	einfo ''
	einfo 'They should be fixed as time passes. Patches/Pull requests welcome...'

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
