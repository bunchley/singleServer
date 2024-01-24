
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-40d28157"
  instance_type = "t2.micro"

  #   add tags to add a name to resource
  tags = {
    Name = "terraform-example"
  }
}