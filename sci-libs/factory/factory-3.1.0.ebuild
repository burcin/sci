# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils autotools
DESCRIPTION="factory is a C++ library for representing multivariate polynomials"

HOMEPAGE="http://www.mathematik.uni-kl.de/pub/Math/Singular/Factory"

SRC_URI="ftp://www.mathematik.uni-kl.de/pub/Math/Singular/Factory/factory-3-1-0.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="singular"

DEPEND="dev-libs/gmp
		>=dev-libs/ntl-5.4.1"

RDEPEND="${DEPEND}"

S="${WORKDIR}/factory"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# If I move this patch to src_prepare and remove src_unpack it
	# does not get applied. Why ?
	epatch "${FILESDIR}"/patch-3.1.0b || die "patching failed"
	eautoreconf
}

src_compile() {
	econf --prefix="${D}/usr" \
		$(use_with singular Singular) ||  die "econf failed"

	# Not doing this explicitly might trigger a race condition
	emake factoryconf.h || die "make failed"
	emake all || die "make failed"
}

src_install() {
	# Another race condition when creating dirs with -j3
	emake -j1 install || die "Install failed"
}