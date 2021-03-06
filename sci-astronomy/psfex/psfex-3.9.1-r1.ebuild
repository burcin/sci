# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils

DESCRIPTION="Extracts models of the Point Spread Function from FITS images"
HOMEPAGE="http://www.astromatic.net/software/psfex"
SRC_URI="http://www.astromatic.net/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc plplot threads"

RDEPEND="virtual/cblas
	sci-libs/atlas
	sci-libs/fftw:3.0
	plplot? ( sci-libs/plplot )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	local mycblas=atlcblas  myclapack=atlclapack
	if use threads; then
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptcblas.so ]] && mycblas=ptcblas
		[[ -e ${EPREFIX}/usr/$(get_libdir)/libptclapack.so ]] && myclapack=ptclapack
	fi
	# fix the configure and not the acx_atlas.m4. the eautoreconf will
	# produce a configure giving  a wrong install Makefile target (to fix)
	sed -i \
		-e "s/-lcblas/-l${mycblas}/g" \
		-e "s/AC_CHECK_LIB(cblas/AC_CHECK_LIB(${mycblas}/g" \
		-e "s/-llapack/-l${myclapack}/g" \
		-e "s/AC_CHECK_LIB(lapack/AC_CHECK_LIB(${myclapack}/g" \
		configure || die "sed acx_atlas.m4 failed"
}

src_configure() {
	econf \
		--with-atlas-incdir="${EROOT}/usr/include/atlas" \
		$(use_with plplot) \
		$(use_enable threads)
}

src_install () {
	default
	use doc && dodoc doc/*.pdf
}
