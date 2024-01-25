
provider "aws" {
  region = "us-east-1"
}




resource "aws_launch_configuration" "example" {
  name_prefix = "terraform-example"
  image_id           = "ami-40d28157"
  instance_type = "t2.micro"
  security_groups = [ "${aws_security_group.instance.id}" ]

  # AWS will execute when the instance is booting
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

# by default AWS doesnt allow incoming/outgoing traffic, so a security group is needed

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  lifecycle {
    create_before_destroy = true
  }
}

# fetch the AZ from your AWS account
data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones =  "${data.aws_availability_zones.all.names}" 

  min_size = 2
  max_size = 10
  
  # parameter to tell the ASG to register each instance in the ELB when that instance is booting
  load_balancers = [ "${aws_elb.example.name}" ]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}



# create a new load balancer to distribute traffic across instances
resource "aws_elb" "example" {
  name = "terraform-asg-example"
  availability_zones = "${data.aws_availability_zones.all.names}"
  security_groups = [ "${aws_security_group.elb.id}" ]

  # route requests
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "${var.server_port}"
    instance_protocol = "http"
  }

  # configure health check
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:${var.server_port}/"
  }
}

# create secruity group for ELB to receive incoming and outgoing traffic
resource "aws_security_group" "elb" {
  name = "terraform-example-elb"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # add to allow elb health checks
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
