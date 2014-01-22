#!/usr/bin/make
REBAR?=./rebar

prefix="/usr/local/bin"

epoch=$(shell date +%s)
year=$(shell date +%Y)

vendor="idubrov"
license="https://github.com/EchoTeam/covertool"

project_name="covertool"
project_version=$(shell git describe --always --tags)

commit_hash=$(shell git log -n 1 --format="%H")

.PHONY : all deps compile test clean
all: deps compile test
deps:
	@$(REBAR) get-deps update-deps
	$(MAKE) -C deps/rebar
compile:
	@$(REBAR) compile escriptize
test:
	-@$(REBAR) skip_deps=true eunit
clean:
	@$(REBAR) clean
	rm -rf ./*.rpm

rpm: all rpm_ll

rpm_ll:
	fpm -s dir \
		-t rpm \
		-a all \
		--prefix=${prefix} \
		--vendor=${vendor} \
		--license=${license} \
		--epoch=${epoch} \
		--name=${project_name} \
		--version=${project_version} \
		--provides=${project_name} \
		./covertool
