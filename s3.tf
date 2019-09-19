resource "aws_s3_bucket" "logger_store" {
	bucket = "logger-store"
	acl = "private"
	tags = { usage = "study" }
}

output "logger_store_arn" {
	value = "${aws_s3_bucket.logger_store.arn}"
}
