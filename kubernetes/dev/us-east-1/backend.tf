# terraform {
#   backend "s3" {
#     bucket = "backend-tf" 
#     key    = "dev/us-east-1/terraform.tfstate"
#     region = "us-east-1"
#     dynamodb_table = "terraform-state-lock"
#   }
# }
