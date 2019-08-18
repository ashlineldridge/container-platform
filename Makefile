build_dir := target
var_file  := development.tfvars
plan_file := $(build_dir)/plan

sh_src := $(shell find . -type f -name '*.sh' -not -path "./vendor/*")

no_color    := \033[0m
ok_color    := \033[32;01m
error_color := \033[31;01m
warn_color  := \033[33;01m

.PHONY: clean
clean:
	@echo "\n$(ok_color)====> Cleaning$(no_color)"
	go clean ./... && rm -rf ./$(build_dir)

.PHONY: plan
plan:
	@echo "\n$(ok_color)====> Running Terraform plan$(no_color)"
	@mkdir -p $(build_dir)
	terraform plan -var-file=$(var_file) -out=$(plan_file)

.PHONY: apply
apply:
	@echo "\n$(ok_color)====> Running Terraform apply$(no_color)"
	terraform apply $(plan_file)

.PHONY: shellcheck
shellcheck:
	@echo "\n$(ok_color)====> Running shellcheck$(no_color)"
	shellcheck $(sh_src)

.PHONY: lint
lint:
	@echo "\n$(ok_color)====> Running shfmt$(no_color)"
	shfmt -i 2 -ci -sr -bn -d $(sh_src)
