# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit distutils

MYPN=ATpy
MYP="${MYPN}-${PV}"

DESCRIPTION="Astronomical tables support Python"
HOMEPAGE="http://atpy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"

RDEPEND=">=dev-python/numpy-1.3
	fits? ( >=dev-python/pyfits-2.1 )
	mysql? ( dev-python/mysql-python )
	postgres? ( dev-db/pygresql )
	sqlite? ( dev-python/pysqlite )
	votable? ( >=dev-python/vo-0.3 )"

DEPEND=">=dev-python/numpy-1.3"

IUSE="+fits mysql postgres sqlite +votable"
SLOT="0"
KEYWORDS="~amd64 ~x86"
LICENSE="GPL-3"

S="${WORKDIR}/${MYP}"

src_test() {
	PYTHONPATH=$(dir -d build/lib*) "${python}" test/test.py || die
}