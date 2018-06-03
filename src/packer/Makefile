PACKER_CACHE_DIR := $(HOME)/.cache/packer
PACKER_LOG_PATH  := $(PACKER_CACHE_DIR)/log.txt
PACKER_LOG       := 1

export PACKER_CACHE_DIR PACKER_LOG_PATH PACKER_LOG

FLAGS            += -force
FLAGS            += -parallel=true

ifdef only
ifeq (,$(findstring null,$(only)))
FLAGS            += -except=null
endif
FLAGS            += -only=$(only)
endif

ifdef except
FLAGS            += -except=$(except)
endif

ifdef PRODUCTION
FLAGS            += -var headless=true
else
FLAGS            += -var headless=false
FLAGS            += -on-error=ask
endif

SHELL            := bash

I                := @printf "\x1b[32;01m%-16s\x1b[0m "
H                := @printf "\x1b[36;01m%-16s\x1b[0m "
II               := @printf "\x1b[32;01m%-16s\x1b[0m\n"
HH               := @printf "\x1b[36;01m%-16s\x1b[0m\n"

ifdef DEBUG
Q                := @echo
else
Q                := @
endif

# Validate templates
validate:
	$(HH) "validate debian.json"
	$(Q) packer validate debian.json
	$(HH) "validate ubuntu.json"
	$(Q) packer validate ubuntu.json
.PHONY: validate

# Build all boxes
all: debian ubuntu
.PHONY: all

# Clean all
clean:
	$(HH) clean
	$(Q) rm -rf *.box *.log output-* packer_cache

# ------------------------------------------------------------------------------
# Debian
# ------------------------------------------------------------------------------

JESSIE_ISO_URL           := http://cdimage.debian.org/mirror/cdimage/archive/8.10.0/amd64/iso-cd/debian-8.10.0-amd64-netinst.iso
JESSIE_ISO_CHECKSUM_URL  := http://cdimage.debian.org/mirror/cdimage/archive/8.10.0/amd64/iso-cd/SHA256SUMS

STRETCH_9_3_ISO_URL          := https://cdimage.debian.org/cdimage/archive/9.3.0/amd64/iso-cd/debian-9.3.0-amd64-netinst.iso
STRETCH_9_3_ISO_CHECKSUM_URL := https://cdimage.debian.org/cdimage/archive/9.3.0/amd64/iso-cd/SHA256SUMS

STRETCH_9_4_ISO_URL          := http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.4.0-amd64-netinst.iso
STRETCH_9_4_ISO_CHECKSUM_URL := http://cdimage.debian.org/debian-cd/current/amd64/iso-cd/SHA256SUMS

#- Using 9.3 to satisfy Huawei

STRETCH_ISO_URL              := $(STRETCH_9_3_ISO_URL)
STRETCH_ISO_CHECKSUM_URL     := $(STRETCH_9_3_ISO_CHECKSUM_URL)

prep: $(PACKER_CACHE_DIR)
$(PACKER_CACHE_DIR):
	$(Q) mkdir -p $@
.PHONY: prep

# Build debian-legacy-server
debian-legacy-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=legacy" \
		-var "codename=jessie" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		-var "iso_url=$(JESSIE_ISO_URL)" \
		-var "iso_checksum_url=$(JESSIE_ISO_CHECKSUM_URL)" \
		\
		debian.json | tee $(@).log
.PHONY: debian-legacy-server

# Build debian-stable-server
debian-stable-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=stable" \
		-var "codename=stretch" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		-var "iso_url=$(STRETCH_ISO_URL)" \
		-var "iso_checksum_url=$(STRETCH_ISO_CHECKSUM_URL)" \
		\
		debian.json | tee $(@).log
.PHONY: debian-stable-server

# Build debian-unstable-server
debian-unstable-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=unstable" \
		-var "codename=sid" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		\
		-only=lxc debian.json | tee $(@).log
.PHONY: debian-unstable-minimal

# Build debian-legacy-minimal
debian-legacy-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=legacy" \
		-var "codename=jessie" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		-var "iso_url=$(JESSIE_ISO_URL)" \
		-var "iso_checksum_url=$(JESSIE_ISO_CHECKSUM_URL)" \
		\
		debian.json | tee $(@).log
.PHONY: debian-legacy-minimal

# Build debian-stable-minimal
debian-stable-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=stable" \
		-var "codename=stretch" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		-var "iso_url=$(STRETCH_ISO_URL)" \
		-var "iso_checksum_url=$(STRETCH_ISO_CHECKSUM_URL)" \
		\
		debian.json | tee $(@).log
.PHONY: debian-stable-minimal

# Build debian-unstable-minimal
debian-unstable-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=debian" \
		-var "suite=unstable" \
		-var "codename=sid" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		\
		-only=lxc debian.json | tee $(@).log
.PHONY: debian-unstable-server

# Build all debian-stable boxes
debian-stable:   debian-stable-minimal debian-stable-server
.PHONY: debian-stable

# Build all debian-unstable boxes
debian-unstable: debian-unstable-minimal debian-unstable-server
.PHONY: debian-unstable

# Build all debian-legacy boxes
debian-legacy:   debian-legacy-minimal debian-legacy-server
.PHONY: debian-legacy

# Build all debian boxes
debian:          debian-stable debian-unstable debian-legacy
.PHONY: debian

# ------------------------------------------------------------------------------
# Ubuntu
# ------------------------------------------------------------------------------

XENIAL_ISO_URL           := http://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04-server-amd64.iso
XENIAL_ISO_CHECKSUM_URL  := http://old-releases.ubuntu.com/releases/xenial/SHA256SUMS

BIONIC_ISO_URL           := http://releases.ubuntu.com/18.04/ubuntu-18.04-desktop-amd64.iso
BIONIC_ISO_CHECKSUM_URL  := http://releases.ubuntu.com/18.04/SHA256SUMS

# Build ubuntu-legacy-server
ubuntu-legacy-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=legacy" \
		-var "codename=xenial" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		-var "iso_url=$(XENIAL_ISO_URL)" \
		-var "iso_checksum_url=$(XENIAL_ISO_CHECKSUM_URL)" \
		\
		ubuntu.json | tee $(@).log
.PHONY: ubuntu-legacy-server

# Build ubuntu-stable-server
ubuntu-stable-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=stable" \
		-var "codename=bionic" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		-var "iso_url=$(BIONIC_ISO_URL)" \
		-var "iso_checksum_url=$(BIONIC_ISO_CHECKSUM_URL)" \
		\
		ubuntu.json | tee $(@).log
.PHONY: ubuntu-stable-server

# Build ubuntu-unstable-server
ubuntu-unstable-server: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=unstable" \
		-var "codename=cosmic" \
		-var "medley=server" \
		-var "hostname=server" \
		-var "boxname=$@" \
		\
		-only=lxc ubuntu.json | tee $(@).log
.PHONY: ubuntu-unstable-server

# Build ubuntu-legacy-minimal
ubuntu-legacy-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=legacy" \
		-var "codename=xenial" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		-var "iso_url=$(XENIAL_ISO_URL)" \
		-var "iso_checksum_url=$(XENIAL_ISO_CHECKSUM_URL)" \
		\
		ubuntu.json
.PHONY: ubuntu-legacy-minimal

# Build ubuntu-stable-minimal
ubuntu-stable-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=stable" \
		-var "codename=bionic" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		-var "iso_url=$(BIONIC_ISO_URL)" \
		-var "iso_checksum_url=$(BIONIC_ISO_CHECKSUM_URL)" \
		\
		ubuntu.json | tee $(@).log
.PHONY: ubuntu-stable-minimal

# Build ubuntu-unstable-minimal
ubuntu-unstable-minimal: prep
	$(HH) $@
	$(Q) packer build $(FLAGS) \
		\
		-var "distribution=ubuntu" \
		-var "suite=unstable" \
		-var "codename=cosmic" \
		-var "medley=minimal" \
		-var "hostname=minimal" \
		-var "boxname=$@" \
		\
		-only=lxc ubuntu.json | tee $(@).log
.PHONY: ubuntu-unstable-minimal

# Build all ubuntu-stable boxes
ubuntu-stable:   ubuntu-stable-minimal ubuntu-stable-server
.PHONY: ubuntu-stable

# Build all ubuntu-unstable boxes
ubuntu-unstable: ubuntu-unstable-minimal ubuntu-unstable-server
.PHONY: ubuntu-unstable

# Build all ubuntu-legacy boxes
ubuntu-legacy:   ubuntu-legacy-minimal ubuntu-legacy-server
.PHONY: ubuntu-legacy

# Build all ubuntu boxes
ubuntu:          ubuntu-stable ubuntu-unstable ubuntu-legacy
.PHONY: ubuntu
