# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/opennota"
GOLANG_PKG_VERSION="5b00aacd5639507d2b039245a278ec9f5505509f"
GOLANG_PKG_BUILDPATH="/cmd/aligncheck /cmd/structcheck /cmd/varcheck"

GOLANG_PKG_DEPENDENCIES=(
	"github.com/kisielk/gotool:58a7a19"
	"github.com/golang/tools:6d483ee -> golang.org/x"
)

inherit golang-single

DESCRIPTION="A set of utilities for checking Go sources "
HOMEPAGE="https://${GOLANG_PKG_IMPORTPATH}/${PN}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

DEPEND=">=dev-lang/go-1.5.1"
