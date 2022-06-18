resource "aws_instance" "app_server" {

  ami           = var.ami
  instance_type = var.instance_type
  key_name = aws_key_pair.deployer.key_name

  tags = merge(
    var.additional_tags,
    {
      Customer = "${local.customer-name}"
    }
  )
  
}