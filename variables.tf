
variable overall {
    description = "Document how a variable is used. Teamates are able to see description when running plan or apply"
    type = string
    default = "nada"
}

variable server_port {
    description = "The port the server will use for the HTTP requests."
    default = 8080
    type = number
}

variable "tags" {
  description = "The map of tags detailing env and project."
  type = map
  default = {
    env = "dev"
    project = "singleServer"
  }
}