resource "aws_security_group" "ecs_sg" {
  name        = "quasar-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.quasar_vpc.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  depends_on = [aws_vpc.quasar_vpc]
}