# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/bioperl/bioperl-9999.ebuild,v 1.2 2009/04/08 20:45:57 weaver Exp $

EAPI=2

ESVN_REPO_URI="http://beast-mcmc.googlecode.com/svn/trunk/"

WANT_ANT_TASKS="ant-junit4"
EANT_GENTOO_CLASSPATH="colt,jdom-1.0,itext,junit-4"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="latin1"
JAVA_PKG_BSFIX_NAME="build.xml build_BEAST_MCMC.xml build_coalsim.xml build_development.xml build_pathogen.xml build_release.xml build_treestat.xml build_vcs.xml"

inherit java-pkg-2 java-ant-2 eutils subversion

DESCRIPTION="Bayesian MCMC of Evolution & Phylogenetics using Molecular Sequences"
HOMEPAGE="http://code.google.com/p/beast-mcmc/"
#SRC_URI="http://beast-mcmc.googlecode.com/files/BEASTv${PV}.tgz"
SRC_URI=""

LICENSE="LGPL"
SLOT="0"
KEYWORDS=""
IUSE="test"

# TODO: sys-cluster/mpijava, dev-java/commons-math
COMMON_DEPS="dev-java/colt:0
	dev-java/jdom:1.0
	dev-java/itext:0
	dev-java/junit:4
	"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPS}"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPS}"

java_prepare() {
	cd lib
	rm -v colt.jar junit-*.jar itext-*.jar jdom.jar || die
#	rm -v commons-math-*.jar
#	sed -i 's/haltonfailure="true"/haltonfailure="false"/' "${S}/build_BEAST_MCMC.xml" || die
	sed -i '/BEAST_LIB/ s|$BEAST|/usr/share/beast|' "${S}"/scripts/* || die
	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from colt
}

src_compile() {
	eant dist_all_BEAST -f build_BEAST_MCMC.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
	eant dist -f build_pathogen.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
}

src_install() {
	java-pkg_dojar bin/dist/*.jar dist/*.jar

	java-pkg_dolauncher beauti --jar beauti.jar --java_args '-Xms64m -Xmx256m'
#	java-pkg_dolauncher beauti --main dr.app.beauti.BeautiApp --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher beast --main dr.app.beast.BeastMain --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher loganalyser --main dr.app.tools.LogAnalyser --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher logcombiner --main dr.app.tools.LogCombiner --java_args '-Xms64m -Xmx256m'
	java-pkg_dolauncher treeannotator --main dr.app.tools.TreeAnnotator --java_args '-Xms64m -Xmx256m'

	insinto /usr/share/${PN}
	doins -r examples || die
	dodoc NOTIFY doc/*.pdf
}

src_test() {
	eant junit -f build_BEAST_MCMC.xml \
		-Dgentoo.classpath=$(java-pkg_getjars ${EANT_GENTOO_CLASSPATH}):$(for i in lib/*.jar; do echo -n "$i:"; done) || die
}