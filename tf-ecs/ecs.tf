resource "aws_ecs_cluster" "main" {
  name = "quasar-cluster"
  depends_on = [
    aws_vpc.quasar_vpc,
    aws_security_group.ecs_sg
  ]
}

resource "aws_ecs_task_definition" "app" {
  family                   = "quasar-app"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512

  container_definitions = jsonencode([
    {
      name      = "app"
      image     = "docker.io/quasarcelestio/test-bk:${var.tag}"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]
      environment = [
        {
          name  = "PORT"
          value = "5000"
        },
        {
          name  = "PG_USER"
          value = var.pg_user
        },
        {
          name  = "PG_HOST"
          value = var.pg_host
        },
        {
          name  = "PG_DATABASE"
          value = var.pg_database
        },
        {
          name  = "PG_PASSWORD"
          value = var.pg_password
        },
        {
          name  = "PG_PORT"
          value = var.pg_port
        }
      ]
    }
  ])
  depends_on = [aws_ecs_cluster.main]
}
resource "aws_ecs_service" "app" {
  name            = "quasar-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.quasar_subnet_1.id, aws_subnet.quasar_subnet_2.id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  depends_on = [aws_ecs_task_definition.app]
}