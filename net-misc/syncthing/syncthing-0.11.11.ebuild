# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

GOLANG_PKG_IMPORTPATH="github.com/${PN}"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_HAVE_TEST=1

inherit systemd golang-single

DESCRIPTION="Syncthing is an application that lets you synchronize your files across multiple devices"
HOMEPAGE="http://syncthing.net"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="systemd"

RDEPEND="systemd? ( >=sys-apps/systemd-219 )"

src_prepare() {
	# FIX: provide a version number
	touch "${S}"/RELEASE || die
	echo "v${PV}" > "${S}"/RELEASE || die
}

src_compile() {
	# Build the package
	${EGO} run build.go clean || die
	${EGO} run build.go -no-upgrade install || die
}

src_install() {
	# install the package
	dobin "${S}"/bin/${PN}

	# install systemd services
	if use systemd; then
		systemd_newunit "${S}"/etc/linux-systemd/system/${PN}@.service  "${PN}@.service"
		systemd_newuserunit "${S}"/etc/linux-systemd/user/${PN}.service "${PN}.service"
	fi
}

src_test() {
	${EGO} run build.go test || die
}