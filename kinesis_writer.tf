
#Define a user role for a customized writer to write into kinesis data stream 
# Writer -> kinesis stream(logger) -> kinesis firehose(deliverman) -> s3(logging store)


# Create a role and specify that it could be assumed by ec2
resource "aws_iam_role" "stream_writer"{
	name = "stream_writer"
	assume_role_policy = <<EOF
{
	"Version":"2012-10-17",
	"Statement" : [
		{
		"Action":["sts:AssumeRole"],
		"Principal":{
			"Service":"ec2.amazonaws.com"
		},
		"Effect":"Allow"
		}
	]
}
EOF
	tags = {usage="logging"}
}

# Create a policy that authorize writing into data stream
resource "aws_iam_policy" "stream_writing_policy"{
	name = "stream_writer_policy"
	policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kinesis:put*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Attach the policy to the role
resource "aws_iam_role_policy_attachment" "attach_policy_to_stream_writer_role" {
	role       = "${aws_iam_role.stream_writer.name}"
	policy_arn = "${aws_iam_policy.stream_writing_policy.arn}"
}


# Create an IAM instance profile which connect the role and the ec2 instance
resource "aws_iam_instance_profile" "stream_writer_profile" {
  name = "stream_writer_profile"
  role = "${aws_iam_role.stream_writer.name}"
}

# Create a ec2 instance to run stream writer
resource "aws_instance" "stream_writer" {

	# Stream writer must use redhat enterprise or in this case, AWS linux
	ami = "ami-04b762b4289fba92b"
	instance_type = "t2.micro"
	count = 1 
	# SG was declared somewhere else
	vpc_security_group_ids = ["sg-01ecc668e32822119"]
	# key was declared somewhere else
	key_name = "machi"
	# Add a role with enough permission to write into data stream
	iam_instance_profile  ="${aws_iam_instance_profile.stream_writer_profile.name}"

	tags= {usage="logging"}
}

output "stream_writer_arn"{
	value = "${aws_instance.stream_writer[0].arn}"
}

output "stream_writer_ip"{
	value = "${aws_instance.stream_writer[0].public_ip}"
}
