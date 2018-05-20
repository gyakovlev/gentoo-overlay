[![Build Status](https://travis-ci.org/gyakovlev/gentoo-overlay.svg?branch=master)](https://travis-ci.org/gyakovlev/gentoo-overlay)
# gyakovlev 
This is my personal portage overlay for [Gentoo Linux](https://gentoo.org/)
Mirror available at [gitlab](https://gitlab.com/gyakovlev/gentoo-overlay)

I do my best to maintain ebuilds according to main repo standard.  
Most packages end up in gentoo, but some may stay here forever.  
WIP/Unstable packages should remain masked.  

## Installation

- using wget
```sh
mkdir -p /etc/portage/repos.conf
wget  -O /etc/portage/repos.conf/gyakovlev.conf https://raw.githubusercontent.com/gyakovlev/gentoo-overlay/master/gyakovlev.conf
```

- using curl
```sh
curl -Lo /etc/portage/repos.conf/gyakovlev.conf --create-dirs https://raw.githubusercontent.com/gyakovlev/gentoo-overlay/master/gyakovlev.conf
```


- [ ] using [eselect-repository](https://packages.gentoo.org/packages/app-eselect/eselect-repository) not yet implemented
- [ ] using [layman](https://packages.gentoo.org/packages/app-portage/layman) not yet implemented


## sync the repo

```sh
emaint sync -r gyakovlev
```

### Contents ([autogenerated](scripts/pre-commit))
[comment]: # (text below will be generated using pre-commit hook. this line is not visible when rendered.)
```Hack
.
├── app-editors/
│   └── sublime-text/
│       ├── Manifest
│       ├── metadata.xml
│       └── sublime-text-3_p3176.ebuild
├── app-shells/
│   └── loksh/
│       ├── loksh-6.3.ebuild
│       ├── Manifest
│       └── metadata.xml
├── dev-util/
│   └── annobin/
│       ├── annobin-5.8.ebuild
│       ├── annobin-9999.ebuild
│       ├── Manifest
│       └── metadata.xml
├── media-fonts/
│   └── plex/
│       ├── Manifest
│       ├── metadata.xml
│       ├── plex-1.0.1.ebuild
│       └── plex-1.0.2.ebuild
├── metadata/
│   └── layout.conf
├── net-firewall/
│   └── opensnitch/
│       ├── Manifest
│       ├── metadata.xml
│       └── opensnitch-9999.ebuild
├── net-news/
│   └── haxor-news/
│       ├── haxor-news-0.4.3.ebuild
│       ├── haxor-news-9999.ebuild
│       ├── Manifest
│       └── metadata.xml
├── profiles/
│   ├── package.mask
│   └── repo_name
├── scripts/
│   └── pre-commit*
├── sys-kernel/
│   └── it87/
│       ├── files/
│       │   └── it87.conf
│       ├── it87-9999.ebuild
│       ├── Manifest
│       └── metadata.xml
├── sys-process/
│   └── glances/
│       ├── glances-2.11.1.ebuild
│       ├── Manifest
│       └── metadata.xml
├── x11-misc/
│   └── slstatus/
│       ├── Manifest
│       ├── metadata.xml
│       └── slstatus-9999.ebuild
├── gyakovlev.conf
└── README.md

22 directories, 37 files
```
