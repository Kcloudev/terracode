resource  "aws_vpc" "sftp-vpc"{
    cidr_block = "${var.vpc_cidr}"
    tags = {
    Name        = "sftp-vpc"
  } 
}

// Private Subnet
resource "aws_subnet" "private_subnet"{
vpc_id = aws_vpc.sftp-vpc.id
cidr_block="${var.private_subnet_cidr}"   
availability_zone = "eu-west-1a"
map_public_ip_on_launch = false
tags = {
    Name        = "S3_subnet"
  }
}

// Internet Access
resource "aws_internet_gateway" "publicgw" {
  vpc_id = aws_vpc.sftp-vpc.id
  tags = {
    Name        = "sftp-gateway"
  } 
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.sftp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.publicgw.id
  }

  tags = {
    Name        = "sftp-internet-route"
  } 

}

resource "aws_subnet" "public_subnet"{
vpc_id = aws_vpc.sftp-vpc.id
cidr_block="${var.public_subnet_cidr}"
availability_zone = "eu-west-1a"
 map_public_ip_on_launch = true
tags = {
    Name        = "sftp_subnet"
  } 
}

// Allow Only SSH/SFTP Connections
resource "aws_security_group" "allow_ssh_sftp" {
  vpc_id = aws_vpc.sftp-vpc.id
  name        = "allow_ssh_sftp"
  description = "Allow SSH/SFTP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name        = "SFTP"
    Environment = "Prod"
  }
}

resource "aws_security_group" "egress_full" {
  vpc_id = aws_vpc.sftp-vpc.id
  name        = "egress_full"
  description = "Allow internet inside EC2 Instance"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

   tags = {
    Name        = "egress_full"
    Environment = "Prod"
  }
}


resource "aws_route_table_association" "public_subnet_integration" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}


// VPC Endpoint For S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.sftp-vpc.id
  service_name      = "com.amazonaws.${var.defaultregion}.s3"
  vpc_endpoint_type = "Gateway"
}



