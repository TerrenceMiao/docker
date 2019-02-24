resource "aws_s3_bucket" "ideation-aws-s3-bucket" {

  bucket = "${var.s3_data_bucket}"
  
  acl = "public-read"
  
  versioning {
    enabled = false
  }

  tags {
    Name = "${var.s3_data_bucket}"
  }
}