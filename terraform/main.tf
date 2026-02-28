terraform {
  backend "s3" {
    bucket = "alura-bucket-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {    
  region = "us-east-1"
}

# HABILITAR PARA DEPLOY EM EC2
# resource "aws_instance" "alura_go_api_dev" {
#     ami           = var.amis["us-east-1"]
#     instance_type = "t3.micro"
#     key_name      = var.key_name
        
#     iam_instance_profile = "GitHubActionsEc2SSMRole"
    
#     vpc_security_group_ids = [
#       aws_security_group.asg_acesso_ssh.id,
#       aws_security_group.asg_alura_go_api_dev.id,
#     ]    

#     tags = {
#         Name = "alura-go-api-dev"
#     }

#     depends_on = [aws_db_instance.postgres_alura_go_dev]
# }

data "aws_secretsmanager_secret" "db" {
  name = "alura_db_go_credentials"
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = data.aws_secretsmanager_secret.db.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
}

resource "aws_db_instance" "postgres_alura_go_dev" {
  allocated_storage    = 20
  engine               = "postgres"
  engine_version       = "17"
  instance_class       = "db.t3.micro"        
  username             = var.db_username != null ? var.db_username : local.db_creds.username
  password             = var.db_password != null ? var.db_password : local.db_creds.password
  parameter_group_name = "default.postgres17"
  skip_final_snapshot  = true
  publicly_accessible  = false
  vpc_security_group_ids = [ aws_security_group.rds.id ]

  tags = {
    Name = "postgres-alura-go-dev"
  }
}

