# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_/}
VUE_PV=${PV:0:3}
DESCRIPTION="Additional backfrops and palettes from NsCDE"
HOMEPAGE="https://github.com/NsCDE/NsCDE"
SRC_URI="https://github.com/NsCDE/NsCDE/releases/download/${MY_PV}/NsCDE-${MY_PV}.tar.gz
	hp-vue? ( https://github.com/NsCDE/NsCDE-VUE/releases/download/${VUE_PV}/NsCDE-VUE-${VUE_PV}.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+hp-vue"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"/NsCDE-${MY_PV}

src_unpack() {
	default
	if use hp-vue; then
		cp "${WORKDIR}"/NsCDE/share/palettes/*.dp ${S}/NsCDE/share/palettes/
		cp "${WORKDIR}"/NsCDE/share/backdrops/*.pm ${S}/NsCDE/share/backdrops/
	fi
	# these come with CDE and collide otherwise:
	rm ${S}/NsCDE/share/palettes/WhiteBlack.dp
	rm ${S}/NsCDE/share/palettes/White.dp
	rm ${S}/NsCDE/share/palettes/Wheat.dp
	rm ${S}/NsCDE/share/palettes/Urchin.dp
	rm ${S}/NsCDE/share/palettes/Tundra.dp
	rm ${S}/NsCDE/share/palettes/Summer.dp
	rm ${S}/NsCDE/share/palettes/SouthWest.dp
	rm ${S}/NsCDE/share/palettes/SoftBlue.dp
	rm ${S}/NsCDE/share/palettes/SkyRed.dp
	rm ${S}/NsCDE/share/palettes/SeaFoam.dp
	rm ${S}/NsCDE/share/palettes/Savannah.dp
	rm ${S}/NsCDE/share/palettes/SantaFe.dp
	rm ${S}/NsCDE/share/palettes/Sand.dp
	rm ${S}/NsCDE/share/palettes/PBNJ.dp
	rm ${S}/NsCDE/share/palettes/Orchid.dp
	rm ${S}/NsCDE/share/palettes/Olive.dp
	rm ${S}/NsCDE/share/palettes/Nutmeg.dp
	rm ${S}/NsCDE/share/palettes/NorthernSky.dp
	rm ${S}/NsCDE/share/palettes/Neptune.dp
	rm ${S}/NsCDE/share/palettes/Mustard.dp
	rm ${S}/NsCDE/share/palettes/Lilac.dp
	rm ${S}/NsCDE/share/palettes/GrayScale.dp
	rm ${S}/NsCDE/share/palettes/Grass.dp
	rm ${S}/NsCDE/share/palettes/Golden.dp
	rm ${S}/NsCDE/share/palettes/Desert.dp
	rm ${S}/NsCDE/share/palettes/Delphinium.dp
	rm ${S}/NsCDE/share/palettes/DarkGold.dp
	rm ${S}/NsCDE/share/palettes/Crimson.dp
	rm ${S}/NsCDE/share/palettes/Clay.dp
	rm ${S}/NsCDE/share/palettes/Cinnamon.dp
	rm ${S}/NsCDE/share/palettes/Chocolate.dp
	rm ${S}/NsCDE/share/palettes/Charcoal.dp
	rm ${S}/NsCDE/share/palettes/Camouflage.dp
	rm ${S}/NsCDE/share/palettes/Cabernet.dp
	rm ${S}/NsCDE/share/palettes/Broica.dp
	rm ${S}/NsCDE/share/palettes/BlackWhite.dp
	rm ${S}/NsCDE/share/palettes/Black.dp
	rm ${S}/NsCDE/share/palettes/BeigeRose.dp
	rm ${S}/NsCDE/share/palettes/Arizona.dp
	rm ${S}/NsCDE/share/palettes/Alpine.dp
	rm ${S}/NsCDE/share/backdrops/Wooly.pm
	rm ${S}/NsCDE/share/backdrops/WaterDrops.pm
	rm ${S}/NsCDE/share/backdrops/SunLogo.pm
	rm ${S}/NsCDE/share/backdrops/Sprinkles.pm
	rm ${S}/NsCDE/share/backdrops/SkyLight.pm
	rm ${S}/NsCDE/share/backdrops/SkyDark.pm
	rm ${S}/NsCDE/share/backdrops/RicePaper.pm
	rm ${S}/NsCDE/share/backdrops/PinStripe.pm
	rm ${S}/NsCDE/share/backdrops/Pebbles.pm
	rm ${S}/NsCDE/share/backdrops/Paver.pm
	rm ${S}/NsCDE/share/backdrops/OldChars.pm
	rm ${S}/NsCDE/share/backdrops/NoBackdrop.pm
	rm ${S}/NsCDE/share/backdrops/Leaves.pm
	rm ${S}/NsCDE/share/backdrops/LatticeBig.pm
	rm ${S}/NsCDE/share/backdrops/Lattice.pm
	rm ${S}/NsCDE/share/backdrops/KnitLight.pm
	rm ${S}/NsCDE/share/backdrops/InlayPlain.pm
	rm ${S}/NsCDE/share/backdrops/InlayColor.pm
	rm ${S}/NsCDE/share/backdrops/Crochet.pm
	rm ${S}/NsCDE/share/backdrops/Corduroy.pm
	rm ${S}/NsCDE/share/backdrops/Convex.pm
	rm ${S}/NsCDE/share/backdrops/Concave.pm
}

src_install() {
	insinto /usr/dt/share/palettes/
	doins NsCDE/share/palettes/*dp
	insinto /usr/dt/share/backdrops/
	doins NsCDE/share/backdrops/*pm
}
