#A typical kinesis data stream definition

resource aws_kinesis_stream "kafka"{
	name = "logger"
	shard_count = 1
	retention_period = 48
	enforce_consumer_deletion = true
	encryption_type = "NONE"
	tags = {usage = "study"}
}

output "kafka_name" {
  value = ["${aws_kinesis_stream.kafka.name}"]
}

output "kafka_arn" {
  value = ["${aws_kinesis_stream.kafka.arn}"]
}


