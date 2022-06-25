### Terraform Backends

Each Terraform configuration can specify a backend, which defines where and how are performed, where state snapshots are stored

Terraform backends can be devided into two parts

#### Standard Backends

* Only store state.
* Does not perform terraform operations eg. Terraform apply. (For operations CLI on the local machine will be used)
* Third-Party Backends. (eg. AWS S3)

#### Enhanced Backends

* Can both store state.
* Can perform terraform operations
* Enhanced backends can be devided further:
    * local - Files and data are stored on the local machine executing terraform commands.
    * remote - Files and data are stored in the cloud (eg. Terraform Cloud).