terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.40.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = format("%s-%s-vpc", var.prefix, random_pet.this.id)
  }
}

variable "prefix" {
  type        = string
  description = "Prefix to many of the resources created which helps as an identifier, could be company name, solution name, etc"
  default     = "iac-lab-demo"
}

variable "region" {
  type        = string
  description = "Region to deploy the solution"
  default     = "ap-southeast-2"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "192.168.1.0/25"
}

resource "random_pet" "this" {
  length = 1
}