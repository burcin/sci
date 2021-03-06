# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils prefix

DESCRIPTION="General-purpose software package for simulation virtually all kinds of solid-state NMR experiments"
HOMEPAGE="http://bionmr.chem.au.dk/bionmr/software/index.php"
SRC_URI="http://www.bionmr.chem.au.dk/download/${PN}/3.1/${PN}-source-${PV}.tbz2"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
LICENSE="GPL-2"
IUSE="gtk threads tk"

RDEPEND="
	dev-libs/libf2c
	virtual/blas
	virtual/cblas
	virtual/lapack
	gtk? ( x11-libs/gtk+:1 )
	tk? ( dev-lang/tk )"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-source-${PV}

src_prepare() {
	edos2unix Makefile
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	epatch "${FILESDIR}"/3.0.1-type.patch
	eprefixify Makefile
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}"
}

src_install() {
	dobin ${PN}
}
