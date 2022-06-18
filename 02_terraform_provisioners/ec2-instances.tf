resource "aws_instance" "my_web_server" {

    ami = "ami-035c5dc086849b5de"
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    user_data = data.template_file.user_data.rendered
    
    #local-exec
    provisioner "local-exec" {
      command = "echo ${self.private_ip} >> private_ip.txt"
    }

    #remote-exec
    provisioner "remote-exec" {
      inline = [
        "echo ${self.private_ip} >> /home/ec2-user/private_ip.txt"
      ]

      connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = "${self.public_ip}"
        private_key = "${file("../id_rsa")}"
      }
    }

    #file
    provisioner "file" {
      content = "Hello.."
      destination = "/home/ec2-user/hello.txt"

      connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = "${self.public_ip}"
        private_key = "${file("../id_rsa")}"
      }
    }

    tags = {
      "Name" = "provisioner.example.net"
    }

}

data "template_file" "user_data" {

    template = file("./userdata.yaml")

}
