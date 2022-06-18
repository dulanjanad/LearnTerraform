### Terraform Provisioners

Terraform Provisioners install software, edit files, and provision machines created with Terraform

Terraform allows to work with two different provisioners
    1. cloud-init
    2. Packer

#### Cloud-Init

This is an industry standard for cross-platform cloud instance initializations. When you launch a VM on a Cloud Service Provider, you'll provide a YAML or Bash Script

#### Packer

Packer is an automated image-builder service. You provide a configuration file to create and provision the machine image and the image is the deleviered to a repository for use

