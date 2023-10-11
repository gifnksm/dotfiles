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
