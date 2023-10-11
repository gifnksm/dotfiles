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

run-%-bootstrap: CONTAINER_NAME ?= dotfiles-test-$(patsubst run-%,%,$@)
run-%-bootstrap: build-image-%-bootstrap $(ARCHIVE) FORCE
	docker run \
		-d --rm --init \
		-v "$(REPO_DIR)/bootstrap.bash:/bootstrap.bash:ro" \
		-v "$(CURDIR)/$(ARCHIVE):/archive.tar.gz:ro" \
		--env ARCHIVE_URL=file:///archive.tar.gz \
		--env NO_PROTO_CHECK=true \
		--env NO_GIT_CLONE=true \
		--env GITHUB_ACTIONS \
		--env GROUP_PREFIX \
		--name $(CONTAINER_NAME) \
		$(patsubst run-%,dotfiles-test-%,$@) \
		sleep infinity

run-%-install-normal: CONTAINER_NAME ?= dotfiles-test-$(patsubst run-%,%,$@)
run-%-install-normal: build-image-%-install-normal $(ARCHIVE) FORCE
	docker run \
		-d --rm --init \
		-v "$(CURDIR)/$(ARCHIVE):/archive.tar.gz:ro" \
		--env ARCHIVE_URL=file:///archive.tar.gz \
		--env GITHUB_ACTIONS \
		--env GROUP_PREFIX \
		--name $(CONTAINER_NAME) \
		$(patsubst run-%,dotfiles-test-%,$@) \
		sleep infinity
	docker exec --user root:root $(CONTAINER_NAME) mkdir /dotfiles
	uid="$$(docker exec $(CONTAINER_NAME) id -u)"; \
	gid="$$(docker exec $(CONTAINER_NAME) id -g)"; \
	docker exec --user root:root $(CONTAINER_NAME) chown -R "$${uid}:$${gid}" /dotfiles
	docker exec $(CONTAINER_NAME) tar -xzf /archive.tar.gz -C /

run-%-install-dry_run: build-image-%-install-dry_run $(ARCHIVE) FORCE
	docker run \
		-d --rm --init \
		-v $(REPO_DIR):/dotfiles:ro \
		--env GITHUB_ACTIONS \
		--env GROUP_PREFIX \
		--name $(CONTAINER_NAME) \
		$(patsubst run-%,dotfiles-test-%,$@) \
		sleep infinity

run-arch-bootstrap:
run-debian_12-bootstrap:
run-ubuntu_22_04-bootstrap:
run-rocky_9-bootstrap:

run-arch-install-normal:
run-debian_12-install-normal:
run-ubuntu_22_04-install-normal:
run-rocky_9-install-normal:

run-arch-install-dry_run:
run-debian_12-install-dry_run:
run-ubuntu_22_04-install-dry_run:
run-rocky_9-install-dry_run:
