#!/usr/bin/bash

function tg() {
	terragrunt $1 --some param \
		--more params \
		--out plan \
}

function tg-bootstrap() {
	# bootstrap tofu
	# detect tofu / terraform
	terragrunt init 
}
