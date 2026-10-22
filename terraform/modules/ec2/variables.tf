# modules/ec2/variables.tf

variable "instance_name" {
  description = "Nome da instância EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância"
  type        = string
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID para a instância"
  type        = string
}

variable "subnet_id" {
  description = "ID da subnet onde a instância será criada"
  type        = string
}

variable "security_group_ids" {
  description = "Lista de Security Group IDs"
  type        = list(string)
}

variable "key_name" {
  description = "Nome do key pair para SSH"
  type        = string
}

variable "user_data" {
  description = "User data script (base64 encoded)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Ambiente"
  type        = string
}

variable "project_name" {
  description = "Nome do projeto"
  type        = string
}