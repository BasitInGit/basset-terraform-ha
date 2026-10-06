resource "aws_launch_template" "basset_app_ha" {
  name          = "basset-app-ha"
  description   = "Launch template for web application instances"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name
  iam_instance_profile {
    name = aws_iam_instance_profile.basset_ha_profile.id
  }


  # Network Configuration
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.basset_ec2_sg.id]
  }

  # Storage Configuration (EBS Volumes)
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }

  # IMDSv2 Enforcement (Security Best Practice)
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required" # Enforces IMDSv2
    http_put_response_hop_limit = 1
  }

  # Startup Script (User Data)
  user_data = filebase64("userdata.sh")

  # Resource Tagging
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "basset-app"
      Environment = "dev"
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}

resource "aws_autoscaling_group" "basset_ha_asg" {
  name_prefix      = "basset-ha-asg-"
  desired_capacity = 3
  min_size         = 3
  max_size         = 6

  # Replace with your actual VPC Subnet IDs
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.basset_app_ha.id
    version = "$Latest"
  }

  # Health check settings
  health_check_type         = "EC2"
  health_check_grace_period = 300

}

