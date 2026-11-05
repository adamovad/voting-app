resource "aws_ecs_cluster" "main" {
  name = "${local.name}-cluster"
}

locals {
  redis_host = aws_elasticache_cluster.redis.cache_nodes[0].address

  db_env = {
    DB_HOST = aws_db_instance.db.address
    DB_PORT = tostring(aws_db_instance.db.port)
    DB_USER = aws_db_instance.db.username
    DB_NAME = aws_db_instance.db.db_name
    DB_SSL  = "true"
  }

  db_secrets = {
    DB_PASSWORD = aws_secretsmanager_secret.db_password.arn
  }
}

module "vote" {
  source = "./modules/service"

  name               = "${local.name}-vote"
  image              = "${data.aws_ecr_repository.service["vote"].repository_url}:${var.image_tag}"
  cluster_id         = aws_ecs_cluster.main.id
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  execution_role_arn = aws_iam_role.exec.arn
  desired_count      = var.desired_count
  container_port     = 80
  target_group_arn   = aws_lb_target_group.vote.arn

  environment = {
    REDIS_HOST = local.redis_host
    OPTION_A   = var.option_a
    OPTION_B   = var.option_b
  }

  depends_on = [aws_lb_listener.vote]
}

module "result" {
  source = "./modules/service"

  name               = "${local.name}-result"
  image              = "${data.aws_ecr_repository.service["result"].repository_url}:${var.image_tag}"
  cluster_id         = aws_ecs_cluster.main.id
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  execution_role_arn = aws_iam_role.exec.arn
  desired_count      = var.desired_count
  container_port     = 80
  target_group_arn   = aws_lb_target_group.result.arn

  environment = local.db_env
  secrets     = local.db_secrets

  depends_on = [aws_lb_listener.result]
}

module "worker" {
  source = "./modules/service"

  name               = "${local.name}-worker"
  image              = "${data.aws_ecr_repository.service["worker"].repository_url}:${var.image_tag}"
  cluster_id         = aws_ecs_cluster.main.id
  subnet_ids         = [for s in aws_subnet.public : s.id]
  security_group_ids = [aws_security_group.ecs.id]
  execution_role_arn = aws_iam_role.exec.arn
  desired_count      = var.desired_count

  environment = merge(local.db_env, { REDIS_HOST = local.redis_host })
  secrets     = local.db_secrets
}