variable "ami" {
  type        = string
  description = "ami"
  default     = "ami-07524133e69bdba59"
}

variable "instance_type" {
  type        = string
  description = "instance type"
  default     = "t3.micro"
}

variable "key_name" {
  type        = string
  description = "key pair"
  default     = "pairing"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
  default     = "vpc-0e00f24a7f3ad70c6"
}

variable "environment" {
  type        = string
  description = "environment"
  default     = "dev"
}

variable "subnet_ids" {
  type        = list(string)
  description = "subnets id"
  default     = ["subnet-0bac2570b997172b7", "subnet-0b815b267e28103f6", "subnet-0d178a51587579494"]
}