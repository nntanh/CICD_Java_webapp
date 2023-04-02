# Define AWS cloud and Asia Pasific region for this pipeline
provider "aws" {
  region = "ap-southeast-1"
}

# Create VPC
resource "aws_vpc" "lab_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "cicd vpc"
  }
}

# Create Internet Gateway 
resource "aws_internet_gateway" "lab_ig" {
  vpc_id = aws_vpc.lab_vpc.id
}

# Create a subnet for all ec2
resource "aws_subnet" "lab_pub_sn" {
  vpc_id = aws_vpc.lab_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "cicd subnet"
  }
}

# Create a rtb to go the internet
resource "aws_route_table" "lab_rtb" {
  vpc_id = aws_vpc.lab_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab_ig.id
  }

  tags = {
    Name = "cicd route table"
  }
}

# Attach rtb to make subnet can go internet
resource "aws_route_table_association" "lab_rtba" {
  subnet_id = aws_subnet.lab_pub_sn.id
  route_table_id = aws_route_table.lab_rtb.id
}

# Create SG for ec2. Allow http, https, ssh, 8080 for Jenkins, 8081 for Nexus
resource "aws_security_group" "lab_sg" {
  name = "CICD SG"
  description = "http https ssh 8080 8081"
  vpc_id = aws_vpc.lab_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

    ingress {
    from_port = 8081
    to_port = 8081
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# Create and install Jenkins ec2
resource "aws_instance" "lab_jenkins_sv" {
  ami = "ami-064eb0bee0c5402c5"
  instance_type = "t2.micro"
  key_name = "awslab_asia"
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  subnet_id = aws_subnet.lab_pub_sn.id
  associate_public_ip_address = true
  user_data = file("./InstallJenkins.sh")
  
  tags = {
    Name = "Jenkins server"
  }
}

# Create and install Ansible ec2
resource "aws_instance" "lab_ansible_ctl" {
  ami = "ami-064eb0bee0c5402c5"
  instance_type = "t2.micro"
  key_name = "awslab_asia"
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  subnet_id = aws_subnet.lab_pub_sn.id
  associate_public_ip_address = true
  user_data = file("./InstallAnsible.sh")
  
  tags = {
    Name = "Ansible controller"
  }
}

# Create and install Nexus ec2
resource "aws_instance" "lab_nexus_sv" {
  ami = "ami-064eb0bee0c5402c5"
  instance_type = "t2.medium"
  key_name = "awslab_asia"
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  subnet_id = aws_subnet.lab_pub_sn.id
  associate_public_ip_address = true
  user_data = file("./InstallNexus.sh")
  
  tags = {
    Name = "Nexus server"
  }
}

# Create and install Docker ec2
resource "aws_instance" "lab_docker" {
  ami = "ami-064eb0bee0c5402c5"
  instance_type = "t2.micro"
  key_name = "awslab_asia"
  vpc_security_group_ids = [aws_security_group.lab_sg.id]
  subnet_id = aws_subnet.lab_pub_sn.id
  associate_public_ip_address = true
  user_data = file("./InstallDocker.sh")
  
  tags = {
    Name = "Docker host"
  }
}
