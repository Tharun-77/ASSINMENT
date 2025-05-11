resource "aws_s3_bucket" "prefect-bucket-47" {
  bucket = "prefect-bucket-47"

  tags = {
    Name        = "Terraform State Bucket"
  }
}
