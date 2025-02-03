resource "local_file" "pet" {
  filename="/root/pets.txt"
  content = "We love pets!"
}

terraform {
  backend "s3" {
    bucket = "terraform-state-bucket01"
    key = "finance/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table="state-locking"
  }
}

resource "aws_s3_bucket" "finance" {
  bucket = "chaedie-finance-250202"
  tags = {
    Description = "Finance and Payroll"
  }
}