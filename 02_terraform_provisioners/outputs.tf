output "instance_private_ip" {
  value = aws_instance.my_web_server.private_ip
}

output "instance_public_ip" {
  value = aws_instance.my_web_server.public_ip
}