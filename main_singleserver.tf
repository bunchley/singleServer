
# provider "aws" {
#   region = "us-east-1"
# }


# resource "aws_instance" "example" {
#   ami           = "ami-40d28157"
#   instance_type = "t2.micro"
#   vpc_security_group_ids = [ "${aws_security_group.instance.id}" ]

#   # AWS will execute when the instance is booting
#   user_data = <<-EOF
#               #!/bin/bash
#               echo "Hello World" > index.html
#               nohup busybox httpd -f -p "${var.server_port}" &
#               EOF

#   #   add tags to add a name to resource
#   tags = {
#     Name = "terraform-example"
#   }
# }

# # by default AWS doesnt allow incoming/outgoing traffic, so a security group is needed

# resource "aws_security_group" "instance" {
#   name = "terraform-example-instance"

#   ingress {
#     from_port = "${var.server_port}"
#     to_port = "${var.server_port}"
#     protocol = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }