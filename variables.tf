#Use US West 2  
provider "aws" {
  region     = "us-west-2"
  #AWS token is stored in ~/.aws/, not declared here 
}

#pre-provisioned vpc
variable "vpc_id" {
  default = "vpc-c5bd6fbd"
}

#availability zone 
variable "az_name"{
  default = "us-west-2b"
  description = "defualt az within us west 2"
}
