# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# inherit

DESCRIPTION="Monomer library used for macromolecular structure building and refinement."
HOMEPAGE="www.ccp4.ac.uk"
SRC_URI="http://dev.gentooexperimental.org/~jlec/science-dist/${P}.tar.gz"

LICENSE="ccp4"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""
RESTRICT="binchecks strip"

RDEPEND="!<sci-chemistry/ccp4-6.1
	!<sci-libs/ccp4-libs-6.1.1-r1"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/dic

src_install() {
	insinto /usr/share/ccp4/data/monomers/
	for i in {a..z} {1..9} *list *.cif *.txt; do
		doins -r ${i} || die
	done
	dodoc *.txt || die
	dohtml *.html || die
}