#common parameters are stored in variables.tf


#The Dynamodb definition
resource "aws_dynamodb_table" "kvdb" {
	name = "machi-dynamodb-instance"
	billing_mode= "PAY_PER_REQUEST"
	hash_key = "gamer_name"
	range_key = "score"
	attribute {
		name = "gamer_name"
		type = "S"
		}
	attribute {
		name = "game_name"
		type = "S"
		}
	attribute {
		name = "score"
		type = "N"
		}
	ttl {
		enabled =  true
		attribute_name = "timetolive"
		}

	server_side_encryption {
		enabled = false
		}

	point_in_time_recovery {
		enabled = false
		}

	global_secondary_index  {
		name = "gamerank"
		hash_key = "game_name"
		range_key = "score"
		projection_type = "INCLUDE"
		non_key_attributes = ["gamer_name"]

	}

	stream_enabled= false
	stream_view_type = "NEW_AND_OLD_IMAGES"

	tags ={
		usage = "logging"
		}

	}

#Output the ID and ARN
output "dynamodb_id" {
  value = ["${aws_dynamodb_table.kvdb.id}"]
}

output "dynamodb_arn" {
  value = ["${aws_dynamodb_table.kvdb.arn}"]
}

