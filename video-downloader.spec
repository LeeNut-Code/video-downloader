Name:           video-downloader
Version:        0.12.28
Release:        1%{?dist}
Summary:        Simple video downloader for YouTube and many other websites

License:        GPLv3+
URL:            https://github.com/unrud/video-downloader
Source0:        https://github.com/unrud/video-downloader/archive/refs/tags/%{version}.tar.gz#/%{name}-%{version}.tar.gz

BuildArch:      noarch
BuildRequires:  meson >= 0.62.0
BuildRequires:  python3-devel
BuildRequires:  gettext
BuildRequires:  glib2-devel

Requires:       python3
Requires:       python3-gobject
Requires:       gtk4
Requires:       yt-dlp
Requires:       ffmpeg

%description
A GUI for yt-dlp that makes it easy to download videos from various websites.

%prep
%autosetup

%build
%meson
%meson_build

%install
%meson_install

%find_lang %{name}

%files -f %{name}.lang
%license COPYING
%doc README.md
%{_bindir}/video-downloader
%{_datadir}/%{name}/
%{_datadir}/applications/com.github.unrud.VideoDownloader.desktop
%{_datadir}/icons/hicolor/*/apps/com.github.unrud.VideoDownloader*.svg
%{_datadir}/glib-2.0/schemas/com.github.unrud.VideoDownloader.gschema.xml
%{_datadir}/metainfo/com.github.unrud.VideoDownloader.metainfo.xml

%changelog
* Wed Jan 10 2024 Video Downloader Developers <packaging@example.com> - 0.12.28-1
- New upstream release

* Wed Jan 03 2024 Video Downloader Developers <packaging@example.com> - 0.12.27-1
- Initial RPM package