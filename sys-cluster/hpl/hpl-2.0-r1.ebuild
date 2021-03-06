# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/hpl/hpl-1.0-r2.ebuild,v 1.1 2005/09/01 11:59:18 pbienst Exp $

EAPI=4
inherit eutils mpi

DESCRIPTION="Portable Implementation of the High-Performance Linpack Benchmark for Distributed-Memory Computers"
HOMEPAGE="http://www.netlib.org/benchmark/hpl/"
SRC_URI="http://www.netlib.org/benchmark/hpl/hpl-${PV}.tar.gz"
LICENSE="HPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="doc"
DEPEND="$(mpi_pkg_deplist)
	virtual/blas
	virtual/lapack"
RDEPEND="${DEPEND}"

src_prepare() {
	local mpicc_path="$(mpi_pkg_cc)"

	cp setup/Make.Linux_PII_FBLAS Make.gentoo_hpl_fblas_x86
	sed -i \
		-e "/^TOPdir/s,= .*,= ${S}," \
		-e '/^HPL_OPTS\>/s,=,= -DHPL_DETAILED_TIMING -DHPL_COPY_L,' \
		-e '/^ARCH\>/s,= .*,= gentoo_hpl_fblas_x86,' \
		-e '/^MPdir\>/s,= .*,=,' \
		-e '/^MPlib\>/s,= .*,=,' \
		-e "/^LAlib\>/s,= .*,= $(pkg-config --libs-only-l blas lapack)," \
		-e "/^LINKER\>/s,= .*,= ${mpicc_path}," \
		-e "/^CC\>/s,= .*,= ${mpicc_path}," \
		-e "/^LINKFLAGS\>/s|= .*|= ${LDFLAGS}|" \
		Make.gentoo_hpl_fblas_x86 || die
}

src_compile() {
	# do NOT use emake here
	mpi_pkg_set_env
	HOME=${WORKDIR} emake -j1 arch=gentoo_hpl_fblas_x86
	mpi_pkg_restore_env
}

src_install() {
	mpi_dobin bin/gentoo_hpl_fblas_x86/xhpl
	mpi_dolib.a lib/gentoo_hpl_fblas_x86/libhpl.a
	mpi_dodoc INSTALL BUGS COPYRIGHT HISTORY README TUNING \
		bin/gentoo_hpl_fblas_x86/HPL.dat
	mpi_doman man/man3/*.3
	if use doc; then
		mpi_dohtml -r www/*
	fi
}

pkg_postinst() {
	local d=$(mpi_root)
	einfo "Remember to copy $(mpi_root)usr/share/doc/${PF}/HPL.dat to your working directory first!"
	einfo "Typically one may run hpl by executing the following:"
	einfo "\"mpiexec -np 4 /usr/bin/xhpl\""
	einfo "where -np specifies the number of processes."
}
