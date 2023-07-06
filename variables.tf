variable "sftp_user_name" {
description  = "SFTP USERNAME"
default="agencyxyz"
}

variable "sftp_password" {
description = "SFTP PASSWORD"
default = "agencyxyz@123"
}

variable "key_location" {
description = "SFTP PASSWORD"
default = "C:/Users/Kartik/Downloads/aws.pem"
}

variable "vpc_cidr" {
description = "VPC CIDR"
default = "10.0.0.0/16"
}

variable "private_subnet_cidr" {
description = "Private Subnet CIDR"
default = "10.0.20.0/24"
}

variable "public_subnet_cidr" {
description = "Public Subnet CIDR"
default = "10.0.10.0/24"
}

variable "bucket_unique_name" {
description = "bucket unique name"
default = "sftp-bucket-agency-data1000082"
}

variable "defaultregion"{
  description = "Default Region"
  default = "eu-west-1"  
 }

variable "instancetype"{
  description = "EC2 instance type"
  default = "t2.micro"  
 }

 variable "keypairname"{
   description = "Existing Keypair For EC2"
   default = "aws" 
 }