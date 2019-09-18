#Use US West 2  
provider "aws" {
  region     = "us-west-2"
  #AWS token is stored in ~/.aws/, not declared here 
}

#pre-provisioned vpc
variable "vpc_id" {
  default = "vpc-c5bd6fbd"
}

# port number of database 
variable "port_number"{
  default = 5439
  description = "port no. for psql"
}

#availability zone 
variable "az_name"{
  default = "us-west-2b"
  description = "defualt az within us west 2"
}

#the S3 idendentifier for snapshot of the destroyed redshift instance
variable "lastredshiftinstance" {
  type = "string"
  description = "The S3 idendentifier to store the snapshot of the destroyed redshift instance"
}

#The real cluster definition
#Please pay special attention to final_snapshot_identifier
resource "aws_redshift_cluster" "olap" {
  cluster_identifier = "machi-redshift-cluster"
  database_name      = "dev"
  master_username    = "machi"
  master_password    = "Master2password"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  vpc_security_group_ids = ["${aws_security_group.redshift_sg.id}"]
  iam_roles = ["arn:aws:iam::094240567632:role/redshiftonbehalfofme"]
  availability_zone  = "${var.az_name}"
  automated_snapshot_retention_period  = 1
  port = "${var.port_number}"
  skip_final_snapshot = false
  final_snapshot_identifier = "${var.lastredshiftinstance}"
  tags = {
    usage = "study"
  }
}

#The associated security group
resource "aws_security_group" "redshift_sg" {
  name        = "redshift_sg"
  description = "Allow Databases traffic"
  vpc_id     = "${var.vpc_id}"
  
  ingress {
    from_port = "${var.port_number}"
    to_port = "${var.port_number}"
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags = {
    usage = "study"
  }
}

output "sg_id" {
  value = ["${aws_security_group.redshift_sg.id}"]
}

output "redshift_id" {
  value = ["${aws_redshift_cluster.olap.id}"]
}

#Defined here, but not used by the cluster
resource "aws_subnet" "olap" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "172.31.64.0/20"
  availability_zone  = "${var.az_name}"

  tags = {
    usage = "study"
  }
}
