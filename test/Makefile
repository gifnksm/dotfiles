MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.SECONDARY: # don't remove intermediate files
.SECONDEXPANSION:

.PHONY: default
default: help

REPO_DIR = $(shell git rev-parse --show-toplevel)
WORK_DIR = target
ARCHIVE = $(WORK_DIR)/archive.tar.gz
TREE_STAMP = $(WORK_DIR)/tree.txt

## Build the project
.PHONY: all
all:

## Print this message
.PHONY: help
help:
	@printf "Available targets:\n\n"
	@awk '/^[a-zA-Z\-_0-9%:\\]+/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = $$1; \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			gsub("\\\\", "", helpCommand); \
			gsub(":+$$", "", helpCommand); \
			printf "  \x1b[32;01m%-24s\x1b[0m %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ \
		if ($$0 !~ /^.PHONY/) { \
			lastLine = $$0 \
		} \
	} \
	' $(MAKEFILE_LIST) | sort -u
	@printf "\n"

.PHONY: FORCE
FORCE:

## Create a repository archive
.PHONY: archive
archive: $(ARCHIVE)

$(ARCHIVE): FORCE | $(WORK_DIR)/
	bin/create_archive $(ARCHIVE) $(TREE_STAMP)

%/:
	mkdir -p $@

define docker_build
	docker buildx build --pull --load \
		-t dotfiles-test-$1 \
		-f $2 \
		--build-arg bootstrap=$3 \
		--build-arg dry_run=$4 \
		.
endef

$(WORK_DIR)/build-image-%-bootstrap.stamp: docker/Dockerfile.% | $(WORK_DIR)/
	$(call docker_build,$(patsubst $(WORK_DIR)/build-image-%.stamp,%,$@),$<,true,false)
	touch $@
$(WORK_DIR)/build-image-%-install-normal.stamp: docker/Dockerfile.% | $(WORK_DIR)/
	$(call docker_build,$(patsubst $(WORK_DIR)/build-image-%.stamp,%,$@),$<,false,false)
	touch $@
$(WORK_DIR)/build-image-%-install-dry_run.stamp: docker/Dockerfile.% | $(WORK_DIR)/
	$(call docker_build,$(patsubst $(WORK_DIR)/build-image-%.stamp,%,$@),$<,false,true)
	touch $@

build-image-arch-bootstrap: $(WORK_DIR)/$$@.stamp
build-image-debian_12-bootstrap: $(WORK_DIR)/$$@.stamp
build-image-ubuntu_22_04-bootstrap: $(WORK_DIR)/$$@.stamp
build-image-rocky_9-bootstrap: $(WORK_DIR)/$$@.stamp

build-image-arch-install-normal: $(WORK_DIR)/$$@.stamp
build-image-debian_12-install-normal: $(WORK_DIR)/$$@.stamp
build-image-ubuntu_22_04-install-normal: $(WORK_DIR)/$$@.stamp
build-image-rocky_9-install-normal: $(WORK_DIR)/$$@.stamp

build-image-arch-install-dry_run: $(WORK_DIR)/$$@.stamp
build-image-debian_12-install-dry_run: $(WORK_DIR)/$$@.stamp
build-image-ubuntu_22_04-install-dry_run: $(WORK_DIR)/$$@.stamp
build-image-rocky_9-install-dry_run: $(WORK_DIR)/$$@.stamp
