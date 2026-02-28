# HABILITAR PARA DEPLOY EM EC2, CASO QUEIRA ACESSAR VIA SSH
# resource "aws_security_group" "asg_acesso_ssh" {
#   name   = "acesso_ssh"
#   description = "Permitir acesso SSH"  
  
#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = var.cdirs_acesso_remoto
#   }

#   tags = {
#     Name = "SSH"
#   }
# }

resource "aws_security_group" "asg_alura_go_api_dev" {
  name        = "app"
  description = "Security group for application instances, also used by RDS"

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "app"
  }
}

resource "aws_security_group" "rds" {
  name        = "allow-postgres-go-api-dev"
  description = "Security group for RDS PostgreSQL allowing access from EC2 instances only"

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.asg_alura_go_api_dev.id]
  }

  tags = {
    Name = "RDS"
  }
}