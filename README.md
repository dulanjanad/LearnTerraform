# Learn Terraform

A Simple Guide for Terraform Learners

### Cheat-sheet

- terraform format
- terraform plan
- terraform apply
- terraform apply -auto-approve
- terraform destroy -auto-approve

### Terraform Variable Files

terraform.tfvars file will be automatically loaded when running terraform apply
can create additional variable files ex: dev.tfvars, stage.tfvars, prod.tfvars and they will not be autoloaded.
specify variable file via the command line for infividual overrides
- -var-file dev.tfvars
can specify variables inline via the command line
- -var ec2_type="t2.micro"
Terraform will watch for environement variables that begin with TF_VAR_ and apply those as variables

### Varibale definition precedence

- Environment variables (TF_VAR_)
- terraform.tfvars
- terraform.tfvars.json
- *.auto.tfvars or *.auto.tfvars.json
- -varr and -var-file
