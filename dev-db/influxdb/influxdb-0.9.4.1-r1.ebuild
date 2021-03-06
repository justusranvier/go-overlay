# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

GOLANG_PKG_IMPORTPATH="github.com/${PN}"
GOLANG_PKG_ARCHIVEPREFIX="v"
GOLANG_PKG_LDFLAGS="-X main.version ${PV} -X main.branch=${PV} -X main.commit=5d42b21"
GOLANG_PKG_HAVE_TEST=1
GOLANG_PKG_HAVE_TEST_RACE=1
GOLANG_PKG_IS_MULTIPLE=1
GOLANG_PKG_USE_GENERATE=1
GOLANG_PKG_USE_CGO=1
GOLANG_PKG_INSTALLSUFFIX="cgo"
GOLANG_PKG_STATIK="-src=./shared/admin"

# Declares dependencies
GOLANG_PKG_DEPENDENCIES=(
	"github.com/gogo/protobuf:6cab0cc9f" # v0.1
	"github.com/hashicorp/raft:4165b47aca"
	"github.com/hashicorp/raft-boltdb:d1e82c1ec3"
	"github.com/hashicorp/go-msgpack:fa3f63826f"
	"github.com/golang/crypto:1e856cbfdf -> golang.org/x"
	"github.com/golang/protobuf:1dceb1a265"
	"github.com/golang/snappy:723cc1e459"
	"github.com/armon/go-metrics:b2d95e5291"
	"github.com/fatih/pool:cba550ebf9 -> gopkg.in/fatih/pool.v2"
	"github.com/peterh/liner:1bb0d1c1a2"
	"github.com/BurntSushi/toml:056c9bc7be"
	"github.com/bmizerany/pat:b8a35001b7"
	"github.com/kimor79/gollectd:61d0deeb4f"
	"github.com/rakyll/statik:274df120e9"
	"github.com/collectd/go-collectd:4439385f75"

	# NOTE: stable release (v1.0) of boltdb is not supported,
	#       HEAD version is required.
	"github.com/boltdb/bolt:04a3e85793"

	# Unit Testing
	"github.com/davecgh/go-spew:2df174808e"
)

inherit user systemd golang-single

DESCRIPTION="Scalable datastore for metrics, events, and real-time analytics"
HOMEPAGE="http://influxdb.com"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"

DEPEND="dev-go/gogo-protobuf"

pkg_setup() {
	ebegin "Creating ${PN} user and group"
		enewgroup ${PN}
		enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
	eend $?
}

src_prepare() {
	golang-single_src_prepare

	golang_fix_importpath_alias \
		"github.com/collectd/go-collectd" \
		"collectd.org"

	# FIX: paths in systemd service
	sed -i \
		-e "s:/opt/${PN}/influxd:/usr/bin/influxd:" \
		-e "s:/etc/opt/${PN}:/etc/${PN}:" \
		scripts/${PN}.service \
		|| die

	# FIX: paths in configuration file
	sed -i \
		"s:/var/opt:/var/lib:" \
		etc/config.sample.toml \
		|| die
}

src_install() {
	golang-single_src_install

	# FIX: /usr/bin/inspect conflicts with dev-libs/boost
	mv "${ED}"/usr/bin/inspect "${ED}"/usr/bin/${PN}-inspect || die

	# Install configuration files
	insinto /etc/${PN}
	newins etc/config.sample.toml ${PN}.conf

	# Install init scripts
	systemd_dounit "${S}"/scripts/${PN}.service
	systemd_install_serviced "${FILESDIR}"/${PN}.service.conf
	systemd_dotmpfilesd "${FILESDIR}/${PN}.conf"

	keepdir /var/log/${PN}
	fowners -R ${PN}:${PN} /var/log/${PN}
}

src_test() {
	if has sandbox $FEATURES && has network-sandbox $FEATURES; then
		eerror "Some tests require 'sandbox', and 'network-sandbox' to be disabled in FEATURES."
	fi

	golang-single_src_test
}

pkg_postinst() {
	elog "The InfluxDB Shell (CLI) is always included within the main package."
	elog "Executing 'influx' will start the CLI and automatically connect to"
	elog "the local InfluxDB instance. The InfluxDB Shell stores that last 1000"
	elog "commands in your home directory in a file called .influx_history."
	elog
	elog "The InfluxDB HTTP API includes a built-in authentication mechanism,"
	elog "based on user credentials, which is disabled by default. To add"
	elog "authentication to InfluxDB set in the [http] section of the"
	elog " config file:"
	elog
	elog "  [http]"
	elog "  ..."
	elog "  auth-enabled = true"
	elog "  ..."
	elog
	elog "By default, InfluxDB sends anonymouse statistics about your InfluxDB"
	elog "instance. If you would like to disable this funcionality, set in"
	elog "the [monitoring] section of your config file:"
	elog
	elog "  [monitoring]"
	elog "  ..."
	elog "  enabled = false"
	elog "  ..."
}