# 使用aws的Virginia区域
provider "aws" {
  region     = "us-west-2"
  #用户token在配置文件里,不在此处声明
}

#安全组的规则声明如下

variable "port_number"{
  default = 5439
  description = "port no. for psql"
}


resource "aws_redshift_cluster" "default" {
  cluster_identifier = "machi-redshift-cluster"
  database_name      = "dev"
  master_username    = "machi"
  master_password    = "Mustbe8characters"
  node_type          = "dc2.large"
  cluster_type       = "single-node"
  vpc_security_group_ids = ["${aws_security_group.redshift_sg.id}"]
  iam_roles = ["arn:aws:iam::094240567632:role/redshiftonbehalfofme"]
#  cluster_subnet_group_name = "redshift_subnet"
#  availability_zone  = "usw2-az4"
#  automated_snapshot_retention_period  = 1
  port = "${var.port_number}"
  skip_final_snapshot = true
}

resource "aws_security_group" "redshift_sg" {
  name        = "redshift_sg"
  description = "Allow Databases traffic"
  vpc_id = "vpc-c5bd6fbd"
  
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
}

output "sg_id" {
  value = ["${aws_security_group.redshift_sg.id}"]
}

