resource "aws_instance" "my_web_server" {

    ami = "ami-035c5dc086849b5de"
    instance_type = "t2.micro"

    tags = {
      "Name" = "provisioner.example.net"
    }
    
}

