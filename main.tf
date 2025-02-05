#vpc
resource "aws_vpc" "CustomVPC" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "CustomVPC"
  }
}

# internet gateway
resource "aws_internet_gateway" "CustomIGW" {
  vpc_id = aws_vpc.CustomVPC.id
  tags = {
    Name = "CustomIGW"
  }
}

# route table
resource "aws_route_table" "PublicRT" {
  vpc_id = aws_vpc.CustomVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.CustomIGW.id
  }
  tags = {
    Name = "PublicRT"
  }
}

resource "aws_subnet" "CustomPublicSubnet1" {
  vpc_id                  = aws_vpc.CustomVPC.id
  cidr_block              = var.CustomPublicSubnet1_cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "CustomPublicSubnet1"
  }
}

resource "aws_subnet" "CustomPublicSubnet2" {
  vpc_id                  = aws_vpc.CustomVPC.id
  cidr_block              = var.CustomPublicSubnet2_cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = true
  tags = {
    Name = "CustomPublicSubnet2"
  }
}

resource "aws_subnet" "CustomPrivateSubnet1" {
  vpc_id            = aws_vpc.CustomVPC.id
  cidr_block        = var.CustomPrivateSubnet1_cidr
  availability_zone = var.az1
  tags = {
    Name = "CustomPrivateSubnet1"
  }
}

resource "aws_subnet" "CustomPrivateSubnet2" {
  vpc_id            = aws_vpc.CustomVPC.id
  cidr_block        = var.CustomPrivateSubnet2_cidr
  availability_zone = var.az2
  tags = {
    Name = "CustomPrivateSubnet2"
  }
}


resource "aws_route_table_association" "publicsubnet1_association" {
  subnet_id      = aws_subnet.CustomPublicSubnet1.id
  route_table_id = aws_route_table.PublicRT.id
}

resource "aws_route_table_association" "publicsubnet2_association" {
  subnet_id      = aws_subnet.CustomPublicSubnet2.id
  route_table_id = aws_route_table.PublicRT.id
}


#Security Group - ALB 

resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow 80/443 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.CustomVPC.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Security Group – EC2 

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Allow 22 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.CustomVPC.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #source_security_group_id = aws_security_group.alb_sg.id
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


#Security Group – RDS 

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Allow 3306 inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.CustomVPC.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    #source_security_group_id = aws_security_group.ec2_sg.id
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.CustomPrivateSubnet1.id, aws_subnet.CustomPrivateSubnet2.id]

  tags = {
    Name = "rds_subnet_group"
  }
}

