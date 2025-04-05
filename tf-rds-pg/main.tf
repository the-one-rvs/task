provider "aws" {
  region = "eu-north-1"
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [
    aws_subnet.quasar_subnet_1.id,
    aws_subnet.quasar_subnet_2.id
  ]

  tags = {
    Name = "My RDS Subnet Group"
  }
}

resource "aws_db_instance" "postgres_rds" {
  identifier              = "quasar-postgres"
  engine                  = "postgres"
#   engine_version          = "15.4"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
#   name                    = "test"
  username                = "postgres"
  password                = "quasar123"
  port                    = 5432
  publicly_accessible     = true
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.quasar_sg.id]

  tags = {
    Name = "QuasarRDS"
  }
}
