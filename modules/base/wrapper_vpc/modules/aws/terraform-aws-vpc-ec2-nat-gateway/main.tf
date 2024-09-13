module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.3.0"
  count   = var.create ? 1 : 0

  name                   = var.name
  ami                    = data.aws_ami.this[0].id
  instance_type          = var.instance_type
  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [module.security_group[0].security_group_id]

  associate_public_ip_address = true
  disable_api_stop            = false

  source_dest_check = false

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance (${var.name})"
  iam_role_policies = {
    AmazonSSMManagedEC2InstanceDefaultPolicy = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
  }

  user_data_base64            = base64encode(local.user_data)
  user_data_replace_on_change = true
  enable_volume_tags          = true
  root_block_device = [
    {
      delete_on_termination = lookup(var.root_block_device, "delete_on_termination", true)
      encrypted             = lookup(var.root_block_device, "encrypted", true)
      iops                  = lookup(var.root_block_device, "iops", null)
      kms_key_id            = lookup(var.root_block_device, "kms_key_id", null)
      volume_size           = lookup(var.root_block_device, "volume_size", 8)
      volume_type           = lookup(var.root_block_device, "volume_type", "gp3")
      throughput            = lookup(var.root_block_device, "throughput", null)
    }
  ]

  tags = var.tags
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  count   = var.create ? 1 : 0

  name                = var.name
  description         = "Security group for Nat Gateway"
  vpc_id              = var.vpc_id
  use_name_prefix     = false
  ingress_cidr_blocks = ["${data.aws_vpc.this[0].cidr_block}"]
  ingress_rules       = ["all-all"]
  egress_rules        = ["all-all"]

  tags = var.tags
}

resource "aws_route" "this" {
  count = var.create ? 1 : 0

  route_table_id         = var.route_table_id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = module.ec2_instance[0].primary_network_interface_id
}

resource "aws_eip" "this" {
  count = var.attach_eip ? 1 : 0

  domain                    = "vpc"
  instance                  = module.ec2_instance[0].id
  associate_with_private_ip = module.ec2_instance[0].private_ip

  tags = var.tags
}

