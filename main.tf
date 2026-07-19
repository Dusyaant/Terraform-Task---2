# 1. Configure the Multi-Region AWS Providers
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}

# 2. Look up the official Ubuntu 24.04 LTS AMI for US-East-1
data "aws_ami" "ubuntu_east" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's Official AWS Owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 3. Look up the official Ubuntu 24.04 LTS AMI for US-West-2
data "aws_ami" "ubuntu_west" {
  provider    = aws.oregon
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# 4. Deploy Nginx EC2 Instance in US East 1 (N. Virginia)
resource "aws_instance" "ec2_region_one" {
  ami           = data.aws_ami.ubuntu_east.id
  instance_type = "t3.micro" # Sandbox & Free-Tier optimized

  # Bash Script to install and start Nginx automatically on boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Nginx Running via Terraform in US-East-1</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Nginx-Virginia-Region"
  }
}

# 5. Deploy Nginx EC2 Instance in US West 2 (Oregon)
resource "aws_instance" "ec2_region_two" {
  provider      = aws.oregon               
  ami           = data.aws_ami.ubuntu_west.id
  instance_type = "t3.micro"

  # Bash Script to install and start Nginx automatically on boot
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Nginx Running via Terraform in US-West-2</h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "Nginx-Oregon-Region"
  }
}