#A typical kinesis delivery stream definition
resource aws_kinesis_firehose_delivery_stream "deliverman"{
	name = "deliverman"
	destination = "extended_s3"
	server_side_encryption {enabled = false}
	extended_s3_configuration {
		bucket_arn = "${aws_s3_bucket.logger_store.arn}"
		role_arn = "${aws_iam_role.deliverman.arn}"
		prefix = "YYYY/MM/DD/HH"
	}
	tags = {usage = "logging"}
}

#Define a user role for this deliverman so it can read from upstream kinesis data stream and write into s3 in downstream

resource "aws_iam_role" "deliverman"{
	name = "deliverman_role"
	assume_role_policy = <<EOF
{
	"Version":"2012-10-17",
	"Statement" : [
		{
		"Action":["sts:AssumeRole"],
		"Principal":{
			"Service":"firehose.amazonaws.com"
		},
		"Effect":"Allow"
		}
	]
	}
EOF
	tags = {usage="logging"}
}

resource "aws_iam_role_policy_attachment" "attach_policy_and_role" {
	role       = "${aws_iam_role.deliverman.name}"
	policy_arn = "${aws_iam_policy.deliverman_policy.arn}"
}


resource "aws_iam_policy" "deliverman_policy"{
	name = "deliverman_policy"
	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_s3_bucket.logger_store.arn}"
    },
    {
      "Action": [
        "kinesis:*"
      ],
      "Effect": "Allow",
      "Resource": "*"

    }
  ]
}
EOF
}



output "deliverman_arn" {
  value = ["${aws_kinesis_firehose_delivery_stream.deliverman.arn}"]
}

output "deliverman_role_arn" {
	value = "${aws_iam_role.deliverman.arn}"
}
