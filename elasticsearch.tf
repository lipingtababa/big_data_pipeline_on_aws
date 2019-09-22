resource "aws_elasticsearch_domain" "logfulltext"{
	domain_name = "logfulltext"
	elasticsearch_version = "1.5"
	tags ={ usage="logging" }
	ebs_options { 
		ebs_enabled = true
		volume_type="standard"
		volume_size= 30
	}
#	encryption_at_rest { enabled = false }
	cluster_config {
		instance_type = "t2.micro.elasticsearch"
		instance_count = 3
		dedicated_master_enabled = false
	}
	node_to_node_encryption {enabled=false}
}
