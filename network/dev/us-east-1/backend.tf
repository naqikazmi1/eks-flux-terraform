# terraform {
#   backend "s3" {
#     bucket = "terraform-centralised-state-us-east-1"
#     key    = "network/dev/us-east-1/terraform.tfstate"
#     dynamodb_table = "terraform-centralised-state-us-east-1"
#     region = "us-east-1"
#   }
# }