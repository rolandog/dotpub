#!/usr/bin/make
##Makefile: {local, foo, bar, ..., baz}.gitignore -> .gitignore
##
##This Makefile does the following things:
## 
##    1. Updates a repository with gitignore files from:
##       <https://github.com/github/gitignore>
## 
##    2. Merges specified .gitignore files into one single file
##
#
# Example usage:
##MAKE TARGET                     OUTCOME
##----------------                ---------------------------------------------
# all                             Make global.gitignore; pulls after >=1 day
# clean                           Removes all generated files
# git-pull-now                    Force pull from gitignore dir
# global.gitignore                Concatenate .gitignore files
# help                            (default) Display this help section
# info                            Displays environment information


# ##############################################################################
# make configuration
# ##############################################################################

# ensure reproducible behaviour across make instances
.POSIX:

# only use one shell (when used with .POSIX, it breaks '@' prefixes)
# .ONESHELL:

# ensure that we display the help message when nothing is specified with make
.DEFAULT_GOAL := help

# remove created files on  error
.DELETE_ON_ERROR:

# tell make to perform a secondary expansion on prerequisite lists
.SECONDEXPANSION:

# disable built-in rules, and warn on undefined variables
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

# see Windows Compatibility in References
# SHELL=C:/Windows/System32/cmd.exe

# detect which shell we're running
WHICH_SH := $(shell which $(SHELL))
IS_BASH := $(findstring "bash","$(WHICH_SH)")

# pass options to the shell (detect bash, otherwise infer /bin/sh)
ifeq "$(IS_BASH)" "bash"
.SHELLFLAGS := -eu -o pipefail -c
else
.SHELLFLAGS := -ec
# .SHELLFLAGS += -o errexit -o nounset
endif

# detect which echo we're running
ECHO := $(shell which echo)

# ##############################################################################
# Platform detection
# ##############################################################################
UNAME_STRING := $(shell uname)

# Linux
ifeq "$(UNAME_STRING)" "Linux"
OS = Linux

# MacOS
else ifeq "$(UNAME_STRING)" "Darwin"
OS = Darwin

# Windows
else ifeq "$(shell echo $(UNAME_STRING) \
 | grep 'MSYS\|MINGW\|CYGWIN' \
 >/dev/null && echo Windows)" "Windows"
OS = Windows

# Other
else
OS = $(UNAME_STRING)
endif

# ##############################################################################
# Formatting Functions
# ##############################################################################

# callable variables that help with formatting and display of information
# they're passed to 

# Formats a string as a title section in the console.
# Param:
#   1. String to format.
title = $(ECHO) -e "\x1b[1m\x1b[32m\#\#\#\# $1\x1b[0m" 1>&2;

# Formats a string into an 'OK' message in the console.
# Param:
#   1. String to format.
ok = $(ECHO) -e "\x1b[1m\x1b[32m[OK] $1\x1b[0m" 1>&2;

# Formats a string into an 'OK' message in the console.
# Param:
#   1. String to format.
print = $(ECHO) -e "$1" 1>&2;

# Returns the name and value of a variable
# Param:
#   1. A text string of the variable's name
print_variable = $(call print,    $1 = $($1))

# Returns the name and value of a group of variables
# Param:
#   1. A list of text strings of the variables' names
print_variables = $(foreach variable,$(1),$(call print_variable,$(variable)))

# Returns the name and value of a variable
# Param:
#   1. A text string of the variable's name
list_items = $(foreach item,$(1),\n        $(item))

# Returns the name and value of a list variable
# Param:
#   1. A text string of the variable's name
print_list_variable = $(call print,    $1 = $(call list_items,$($1)))

# Returns the name and value of a group of list variables
# Param:
#   1. A list of text strings of the variables' names
print_list_variables = $(foreach variable,$(1),$(call print_list_variable,$(variable)))


# ##############################################################################
# Git
# ##############################################################################

# requirements for the gitignore file
GITIGNORE_DIR:=$(XDG_DATA_HOME)/gitignore
GITIGNORE_FETCH_HEAD:=$(GITIGNORE_DIR)/.git/FETCH_HEAD

# if head is newer than 1 day
ifeq "$(shell find $(GITIGNORE_FETCH_HEAD) -mmin +1440)" ""
DAILY_TARGET:=
# if head is older than 1 day
else
DAILY_TARGET:=git-pull-now
endif

# our own custom additions
GITIGNORE_FILES:=local.gitignore

# append selected files from repository
GITIGNORE_FILES+=\
 $(addprefix $(GITIGNORE_DIR)/,\
 community/Linux/Snap.gitignore\
 community/Python/JupyterNotebooks.gitignore\
 community/OpenSSL.gitignore\
 Global/Archives.gitignore\
 Global/Backup.gitignore\
 Global/Diff.gitignore\
 Global/Emacs.gitignore\
 Global/Images.gitignore\
 Global/GPG.gitignore\
 Global/LibreOffice.gitignore\
 Global/Linux.gitignore\
 Global/macOS.gitignore\
 Global/MicrosoftOffice.gitignore\
 Global/Syncthing.gitignore\
 Global/Vim.gitignore\
 Global/Windows.gitignore\
 Elisp.gitignore\
 Python.gitignore\
 TeX.gitignore)

# ##############################################################################
# Documents to Process (Sources, Targets, Intermediates)
# ##############################################################################

# helper variables
comma:= ,
empty:=
percent:= %
space:= $(empty) $(empty)

# Declare definition files
SECONDARY_FILES:=

# Output files that are costly to produce
PRECIOUS_FILES:=global.gitignore

# Declare files that may be pre-processed or are intermediary
INTERMEDIATE_FILES:=

# define documents to be removed
CLEANUP_FILES:=$(strip\
 $(PRECIOUS_FILES)\
 $(INTERMEDIATE_FILES)\
 $(SECONDARY_FILES))

ALL_TARGETS:=$(strip\
 $(DAILY_TARGET)\
 $(PRECIOUS_FILES))

# ##############################################################################
# Targets
# ##############################################################################

.PHONY: all
all : $(ALL_TARGETS); @ ## Make global.gitignore; pulls after >=1 day

.PHONY: clean
clean:; @ ## Removes all generated files
	rm $(CLEANUP_FILES)
	@$(call ok,"clean")

# special target to ensure target is build once every day
.PHONY: git-pull-now
git-pull-now:: ; @ ## Force pull from gitignore dir
git-pull-now:: $(GITIGNORE_DIR)
	git -C $< pull
	@$(call ok,"$@")

# ensure we're up-to-date with current gitignore standards
global.gitignore : $(GITIGNORE_FILES); @ ## Concatenate .gitignore files
	cat $^ > $@
	@$(call ok,"$@")

.PHONY: help
help: $(firstword $(MAKEFILE_LIST)); @ ## (default) Display this help section
# Display any lines that start with ##
	@sed -n 's/^##//p' $<
# Find rules and format them accordingly
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ \
		{\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $<
 
.PHONY: info
info:; @ ## Displays environment information
	@$(call title,"OS and Environment Info")
	@$(call print_variables,OS WHICH_SH MAKEFLAGS)
	@$(call title,"Git Files")
	@$(call print_variables,GITIGNORE_DIR)
	@$(call print_list_variable,GITIGNORE_FILES)
	@$(call title,"Secondary Files")
	@$(call print_variables,SECONDARY_FILES)
	@$(call title,"Intermediate Files")
	@$(call print_variables,INTERMEDIATE_FILES)
	@$(call title,"Precious Files")
	@$(call print_variables,PRECIOUS_FILES)
	@$(call ok,"info")

# TODO Create tests
# .PHONY: test
# tests:: ; @ # Perform Makefile, git, and .gitignore tests
# tests:: test-help test-info test-git test-clean
#	

# TODO Review Meta-Programming via eval and call functions
# Perhaps we might be able to reduce the size of this Makefile
# https://make.mad-scientist.net/the-eval-function/


# ##############################################################################
# Git related targets (.gitignore file related)
# ##############################################################################

# empty recipe to avoid false-positive automatic rule generation
# we're using an order-only pre-requisite that is satisfied at most once per day
$(GITIGNORE_FILES): | $(GITIGNORE_DIR);

# originally an empty recipe to avoid false-positive automatic rule generation,
# but now we're specifically pulling updates from the repo as a separate step
$(GITIGNORE_DIR) :
	[ -n "$(find $@/.git/FETCH_HEAD -mmin +1440)" ] && git -C $@ pull
	@$(call ok,"$@")


# ##############################################################################
# Pattern matching and conversions
# ##############################################################################



# ##############################################################################
# Special Targets
# ##############################################################################

# tells make to not automatically delete files;
.SECONDARY: $(SECONDARY_FILES)

# tells make that these files CAN be deleted, as they're intermediary files
.INTERMEDIATE: $(INTERMEDIATE_FILES)

# tell make that these files are important, as they are costly to produce
.PRECIOUS: $(PRECIOUS_FILES)

