# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

GOLANG_PKG_IMPORTPATH="github.com/bitly"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_IS_MULTIPLE=1
GOLANG_PKG_HAVE_TEST=1

# Declare dependencies
GOLANG_PKG_DEPENDENCIES=(
	"github.com/BurntSushi/toml:2dff11163e"
	"github.com/bitly/go-hostpool:58b95b10d6"
	"github.com/bitly/go-nsq:0f97a46d80"
	"github.com/bitly/go-simplejson:18db6e68d8"
	"github.com/bmizerany/perks:6cb9d9d729"
	"github.com/mreiferson/go-options:2cf7eb1fdd"
	"github.com/mreiferson/go-snappystream:028eae7ab5"
	"github.com/bitly/timer_metrics:afad1794bb"
	"github.com/blang/semver:9bf7bff48b"
	"github.com/julienschmidt/httprouter:6aacfd5ab5"
)

inherit golang-single

DESCRIPTION="A real-time distributed messaging platform, written in GoLang"
HOMEPAGE="http://nsq.io"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 arm"