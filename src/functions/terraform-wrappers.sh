#!/bin/bash

function bootstrap_tf_module() {
	mkdir $1
	touch $1/{main.tf,variables.tf,providers.tf,outputs.tf,README.md,CHANGELOG,LICENSE}
}
