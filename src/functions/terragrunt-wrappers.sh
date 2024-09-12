#!/usr/bin/bash

function tg() {
	terragrunt $1 --some param \
		--more params \
		--out plan \
}
