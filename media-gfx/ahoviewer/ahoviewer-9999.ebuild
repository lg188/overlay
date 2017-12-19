# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils vcs-snapshot fdo-mime gnome2-utils

DESCRIPTION="A GTK2 image viewer, manga reader, and booru browser"
HOMEPAGE="https://github.com/ahodesuka/ahoviewer"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/ahodesuka/ahoviewer.git"
	inherit git-r3
else
	SRC_URI="https://github.com/ahodesuka/ahoviewer/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+gstreamer +libsecret +rar +zip"

DEPEND="
	>=dev-cpp/glibmm-2.36.0:2
	>=dev-cpp/gtkmm-2.20.0:2.4
	>=dev-libs/libconfig-1.4
	>=net-misc/curl-7.16.0
	dev-libs/libxml2
	gstreamer? ( media-libs/gstreamer:1.0 )
	libsecret? ( app-crypt/libsecret )
	rar? ( app-arch/unrar )
	zip? ( dev-libs/libzip )
"
RDEPEND="${DEPEND}
	gstreamer? (
		media-libs/gst-plugins-base:1.0[X]
		media-libs/gst-plugins-good:1.0
		|| (
			media-plugins/gst-plugins-vpx
			media-plugins/gst-plugins-libav
		)
	)
"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable gstreamer gst) \
		$(use_enable libsecret) \
		$(use_enable rar) \
		$(use_enable zip)
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}