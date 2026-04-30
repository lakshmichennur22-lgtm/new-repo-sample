aws_region  = "us-east-1"
vpc_cidr    = "10.0.0.0/16"
vpc_name    = "my-vpc"

public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets    = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones = ["us-east-1a", "us-east-1b"]

ami_id        = "ami-0c02fb55956c7d316"
instance_type = "t3.micro"
key_name      = "jenkinskey-new"
instance_name = "my-ec2-instance"