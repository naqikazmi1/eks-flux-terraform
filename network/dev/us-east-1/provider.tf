provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.env
      Project     = var.identifier
    }
  }
}