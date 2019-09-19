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
  description = "default az within us west 2"
}

#pre-defined ssh key
variable "key_name" {
	default = "machi"
	description = "KMS key for SSH access authentication"
}

#pre-defined security group
variable "ec2_sg" {
	default = "sg-01ecc668e32822119"
	description = "Security group Id for a EC2 instance"
}
