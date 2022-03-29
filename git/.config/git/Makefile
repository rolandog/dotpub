#!/usr/bin/make

# ##############################################################################
# license
# ##############################################################################

# Makefile (dotpub): automating gitignore tasks
# Copyright (C) 2022  Rolando Garza

# This file is part of dotpub.

# dotpub is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# dotpub is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with dotpub.  If not, see <https://www.gnu.org/licenses/>.


# ##############################################################################
# usage
# ##############################################################################

##usage: make [TARGET]...
##  or:  make [TARGET]... VARIABLE=value...
##  or:  make [help]
##  or:  make [info]
##  or:  make [license]
##  or:  make [version]
##
##Pull from gitignore repository and merge into global.gitignore.
##
##Targets:
#  all                        global.gitignore, git pull after 1 day
#  clean                      removes all generated files
#  git-pull-now               git pull in gitignore dir
#  global.gitignore           concatenate .gitignore files
#  help                       (default) show this message and exit
#  info                       show environment information and exit
#  license                    show license information and exit
#  version                    show program version number and exit
#
#Report bugs to: <https://todo.sr.ht/~rolandog/dotpub>
#dotpub home page: <https://sr.ht/~rolandog/dotpub>
#Source:
#  <https://git.sr.ht/~rolandog/dotpub/tree/main/item/git/.config/git/Makefile>


# ##############################################################################
# make configuration
# ##############################################################################

# ensure reproducible behaviour across make instances
.POSIX:

# only use one shell (it may break '@' prefixes with .POSIX)
#.ONESHELL:

# ensure that we display the help message when nothing is specified with make
.DEFAULT_GOAL := help

# remove created files on  error
.DELETE_ON_ERROR:

# tell make to perform a secondary expansion on prerequisite lists
.SECONDEXPANSION:

# disable built-in rules, and warn on undefined variables
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules


# ##############################################################################
# platform detection
# ##############################################################################

# system information
UNAME := $(shell uname)

# linux
ifeq ($(UNAME),Linux)
OS = Linux

# mac
else ifeq ($(UNAME),Darwin)
OS = Darwin

# windows
else ifeq ($(shell echo $(UNAME) | grep -q 'MSYS\|MINGW\|CYGWIN' && echo t),t)
OS = Windows

# other
else
OS = $(UNAME)
endif


# ##############################################################################
# program information functions
# ##############################################################################

# gets symbolic link or path, returns self in case of built-in
# algorithm, line by line:
#   - test invocation first of ls -dl $1
#   - if no error, then return that value
#   - ok, it's probably a built-in, return the same name
# param:
define getlongdirlist =
$(shell [ -n "$$(ls -dl $(1) 2>/dev/null)" ] \
&& echo "$$(ls -dl $(1))" \
|| echo "$(1)")
endef

# finds program name, at most 1 symbolic link away
# algorithm, line by line:
#   - call command -v on program/path/name
#   - check if it's a symbolic link
#   - get the word at the end of the line
# param:
#   1. program to find the name of
define progname =
$(shell echo "$(call getlongdirlist, $(shell command -v $(1)))" \
| grep -Eo -m 1 '[[:alpha:]]+$$')
endef

# finds program's path, at most 1 symbolic link away
# algorithm, line by line:
#   - call command -v on progname's result
# param:
#   1. program to find the path of
whichprog = $(shell command -v $(call progname,$(1)))

# finds the version of a program.
# algorithm, line by line:
#   - try calling $(1) --version but first check for errors
#   - there was no error; actually call $(1) --version
#     - get the first match of something like a SemVer number
#   - ok, there was an error... then we need to fall back to apt
#     - match the version line
# param:
#   1. program to find a version of
progvers = $(shell [ -n "$$($(1) --version 2>/dev/null)" ] \
 && echo "$$($(1) --version \
 | grep -Eo -m 1 '\b([0-9]+\.[.0-9]{1,})\b')" \
 || echo "$$(apt show $1 2>/dev/null \
 | sed -En 's/^Version\:[[:space:]](.+)$$/\1/p')")

# sed extended regexp compatible paths
SED_PWD := $(shell echo "${PWD}"\
 | sed -E 's/\//\\\//g'\
 | sed -E 's/\./\\\./g')
SED_HOME := $(shell echo "${HOME}"\
 | sed -E 's/\//\\\//g')

# contracts a long path into a more readable path
# param:
#   1. a unix-type path
shrink = $(shell echo "$(1)"\
 | sed -E "s/^$(SED_PWD)\/(.+)/\.\/\1/g"\
 | sed -E "s/^$(SED_HOME)\/(.+)/~\/\1/g")


# ##############################################################################
# shell configuration
# ##############################################################################

# force a particular shell
# SHELL=/usr/bin/bash

# see Windows Compatibility in References
# SHELL=C:/Windows/System32/cmd.exe

# detect which shell we're running
SHELL_NAME := $(call progname,$(SHELL))

# test for bash
ifeq ($(SHELL_NAME),bash)
IS_BASH := true
else
IS_BASH := false
endif

# test for dash
ifeq ($(SHELL_NAME),dash)
IS_DASH := true
else
IS_DASH := false
endif

# pass options to the shell (detect bash, otherwise infer /bin/sh)
ifeq ($(IS_BASH),true)
.SHELLFLAGS := -eu -o pipefail -c
else
.SHELLFLAGS := -ec
endif


# ##############################################################################
# meta-programming
# ##############################################################################

# callable function to create a rule
# https://make.mad-scientist.net/the-eval-function/
define ONEPHONYRULE
.PHONY: $1
$1:
	stow $$@

endef


# ##############################################################################
# formatting functions
# ##############################################################################

# helper variables
comma := ,
empty :=
percent := %
space := $(empty) $(empty)
define newline


endef

# helper functions to format and display information

# formats a string as a title section in the console.
# param:
#   1. String to format.
ifeq ($(IS_BASH),true)
title = echo -e '\x1b[1m\x1b[32m\#\#\# $1\x1b[0m';
else
title = echo '\#\#\# $1';
endif

# formats a string into an 'OK' message in the console.
# param:
#   1. String to format.
ifeq ($(IS_BASH),true)
ok = echo -e '\x1b[1m\x1b[32m[OK] $1\x1b[0m';
else
ok = echo '[OK] $1';
endif

# formats a string into a message in the console.
# param:
#   1. String to format.
#   2. Text width to target
#   3. Number of spaces to indent the text
1 :=
2 :=
3 :=
ifeq ($(IS_BASH),true)
print = echo -e '$1' \
 | fold -s -w $(if $2,$2,80) \
 | pr -T -o $(if $3,$3,0);
else
print = echo '$1' \
 | fold -s -w $(if $2,$2,80) \
 | pr -T -o $(if $3,$3,0);
endif

# returns the name and value of a variable
# param:
#   1. A text string of the variable's name
print_variable = $(call print,$1 = $($1),76,4)

# returns the name and value of a group of variables
# param:
#   1. A list of text strings of the variables' names
print_variables = $(foreach variable,$(1),$(call print_variable,$(variable)))

# returns the name and value of a variable
# param:
#   1. A text string of the variable's name
list_items = $(foreach item,$(1),$(call shrink,$(item)))

# returns the name and value of a list variable
# param:
#   1. A text string of the variable's name
print_list_variable = $(call print,$1 =,76,4)\
 $(call print,$(call list_items,$($1)),72,8)

# returns the name and value of a group of list variables
# param:
#   1. A list of text strings of the variables' names
print_list_variables = $(foreach variable,$(1),$(call print_list_variable,$(variable)))

# format the string of a program's version
# param:
#   1. program name
showprog = $(1)\
 ($(call whichprog,$(1))),\
 version: $(call progvers,$(call progname, $(1)))

# format the string of a program's version
# param:
#   1. a variable like MAKE or SHELL
showprogvar = $(1) = $($(1))\
 ($(call whichprog,$($(1)))),\
 version: $(call progvers,$(call progname, $($(1))))

# print the string of a program's version
# param:
#   1. program name
printprog = $(call print,$(call showprog,$(1)),76,4)

# print the string of a program's version
# param:
#   1. program name
printprogvar = $(call print,$(call showprogvar,$(1)),76,4)

# print the strings of several program's versions
#   1. program names
printprogs = $(foreach prog,$(1),$(call printprog,$(prog)))

# print the strings of several program's versions
#   1. program names
printprogvars = $(foreach prog,$(1),$(call printprogvar,$(prog)))


# ##############################################################################
# informative variables
# ##############################################################################

AWK_PATTERN := /^[^\t].+?:.*?\#\#/
ifeq ($(IS_BASH),true)
AWK_PRINT := '$(AWK_PATTERN) { printf "\033[36m  %-25s\033[0m %s\n", $$1, $$NF }'
else
AWK_PRINT := '$(AWK_PATTERN) {printf "  %-25s %s\n", $$1, $$NF}'
endif

# license variables
AUTHOR = Rolando Garza
THIS_FILE = Makefile
THIS_PROGRAM = dotpub
VERSION_NO = 0.0.1
YEAR := $(shell date -u +'%Y')

# bottom part from help
define HELP_FOOTNOTE_TEXT =

Report bugs to: <https://todo.sr.ht/~rolandog/$(THIS_PROGRAM)>
$(THIS_PROGRAM) home page: <https://sr.ht/~rolandog/$(THIS_PROGRAM)>
Source <https://git.sr.ht/~rolandog/$(THIS_PROGRAM)/tree/main/item/$(THIS_FILE)>
endef

HELP_FOOTNOTE := $(subst $(newline),\n,${HELP_FOOTNOTE_TEXT})

# text for printed license
define LICENSE =
$(THIS_FILE) ($(THIS_PROGRAM)): automating gitignore tasks
Copyright (C) $(YEAR)  $(AUTHOR)

This file is part of $(THIS_PROGRAM).

$(THIS_PROGRAM) is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

$(THIS_PROGRAM) is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with $(THIS_PROGRAM).  If not, see <https://www.gnu.org/licenses/>.
endef

# text for version info
define VERSION =
$(THIS_FILE) ($(THIS_PROGRAM)) $(VERSION_NO)

Copyright (C) $(YEAR)  $(AUTHOR).
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by $(AUTHOR).
endef


# ##############################################################################
# git
# ##############################################################################

GIT = git

# requirements for the global.gitignore file
# i.e. ~/.local/share/gitignore
GITIGNORE_DIR:=$(XDG_DATA_HOME)/gitignore
# i.e. ~/.local/share/gitignore/.git/FETCH_HEAD
GITIGNORE_FETCH_HEAD:=$(GITIGNORE_DIR)/.git/FETCH_HEAD

# if FETCH_HEAD is newer than 1 day (or if it doesn't exist)
ifeq ($(shell find $(GITIGNORE_FETCH_HEAD) -mmin +1440 2>/dev/null),)
DAILY_TARGET:=
# if FETCH_HEAD is older than 1 day
else
DAILY_TARGET:=git-pull-now
endif

# our own custom additions
GITIGNORE_FILES:=local.gitignore

# github gitignore files from external repository
GITHUB_GITIGNORE_FILES:=$(strip $(addprefix $(GITIGNORE_DIR)/,\
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
 TeX.gitignore))

# append selected files from repository
GITIGNORE_FILES += $(GITHUB_GITIGNORE_FILES)


# ##############################################################################
# files to process
# ##############################################################################

# track this Makefile
THIS_MAKEFILE := $(firstword $(MAKEFILE_LIST))

# declare secondary files
SECONDARY_FILES:=

# output files that are costly to produce
PRECIOUS_FILES:=global.gitignore

# declare files that may be pre-processed or are intermediary
INTERMEDIATE_FILES:=

# define documents to be removed
CLEANUP_FILES:=$(strip\
 $(PRECIOUS_FILES)\
 $(INTERMEDIATE_FILES)\
 $(SECONDARY_FILES))

# targets run when executing 'make all'
ALL_TARGETS:=$(strip\
 $(DAILY_TARGET)\
 $(PRECIOUS_FILES))

# ##############################################################################
# targets
# ##############################################################################

.PHONY: all
all : $(ALL_TARGETS); @ ## global.gitignore, git pull after 1 day

.PHONY: clean
clean:; @ ## removes all generated files
	rm $(CLEANUP_FILES)
	@$(call ok,clean)

# perform 'git pull' inside gitignore dir
.PHONY: git-pull-now
git-pull-now:: ; @ ## git pull in gitignore dir
git-pull-now:: $(GITIGNORE_DIR)
	git -C $< pull
	@$(call ok,$@)

# ensure we're up-to-date with current gitignore standards
global.gitignore : $(GITIGNORE_FILES); @ ## concatenate .gitignore files
	cat $^ > $@
	@$(call ok,$@)

.PHONY: help
help: $(THIS_MAKEFILE); @ ## (default) show this message and exit
# display any lines that start with ##
	@sed -n 's/^##//p' $<
# find target rules and format them accordingly
	@awk -F ':|##' $(AWK_PRINT) $<
# display footer
	@$(call print,$(HELP_FOOTNOTE))
 
.PHONY: info
info:; @ ## show environment information and exit
# os and environment info
	@$(call title,os and environment info)
	@$(call print_variables,OS)
	@$(call printprogvar,MAKE)
	@$(call print_variables,MAKEFLAGS MAKECMDGOALS)
	@$(call title,shell info)
	@$(call printprogvar,SHELL)
	@$(call print_variables,.SHELLFLAGS)
# git options and files
	@$(call title,git files)
	@$(call printprogvar,GIT)
	@$(call print_variables,GITIGNORE_DIR)
	@$(call print_list_variable,GITIGNORE_FILES)
# secondary files
	@$(call title,secondary files)
	@$(call print_variables,SECONDARY_FILES)
# intermediate files
	@$(call title,intermediate files)
	@$(call print_variables,INTERMEDIATE_FILES)
# precious files
	@$(call title,precious files)
	@$(call print_variables,PRECIOUS_FILES)

.PHONY: license
license:; @ ## show license information and exit
	@$(info $(LICENSE))

.PHONY: version
version:; @ ## show program version number and exit
	@$(info $(VERSION))

# TODO create tests
# .PHONY: test
# tests:: ; @ # perform Makefile, git, and .gitignore tests
# tests:: test-help test-info test-git test-clean
#	some-test


# ##############################################################################
# git related targets (.gitignore file related)
# ##############################################################################

# order-only pre-requisite satisfied by pulling in gitignore dir once
$(GITHUB_GITIGNORE_FILES): | $(GITIGNORE_FETCH_HEAD);

# order-only pre-requisite that is satisfied by creating gitignore directory
$(GITIGNORE_FETCH_HEAD) : $(GITIGNORE_DIR)
	git -C $< pull
	@$(call ok,$@)

# clone into specified directory (creates the directory)
$(GITIGNORE_DIR) :
	git clone 'https://github.com/github/gitignore.git' $@
	@$(call ok,$@)


# ##############################################################################
# special targets
# ##############################################################################

# tells make to not automatically delete files;
.SECONDARY: $(SECONDARY_FILES)

# tells make that these files CAN be deleted, as they're intermediary files
.INTERMEDIATE: $(INTERMEDIATE_FILES)

# tell make that these files are important, as they are costly to produce
.PRECIOUS: $(PRECIOUS_FILES)

