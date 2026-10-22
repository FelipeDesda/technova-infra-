resource "aws_security_group" "this" {
  name        = var.name
  description = "Security Group ${var.name}"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules

    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permite todo trafego de saida"
  }

  tags = {
    Name        = var.name
    Project     = var.project_name
    Environment = var.environment
  }
}

# Adicionar regra para HTTPS (porta 443)
resource "aws_security_group_rule" "allow_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.technova_api.id
  description       = "Allow HTTPS inbound"
}