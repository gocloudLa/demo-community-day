module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.2"

  name = local.common_name
  cidr = lookup(var.vpc_parameters, "vpc_cidr", "")

  azs = ["${local.metadata.aws_region}a", "${local.metadata.aws_region}b", "${local.metadata.aws_region}c"]

  private_subnets     = lookup(var.vpc_parameters, "private_subnets", [])
  public_subnets      = lookup(var.vpc_parameters, "public_subnets", [])
  database_subnets    = lookup(var.vpc_parameters, "database_subnets", [])
  elasticache_subnets = lookup(var.vpc_parameters, "elasticache_subnets", [])

  enable_ipv6 = lookup(var.vpc_parameters, "enable_ipv6", false)

  manage_default_vpc = lookup(var.vpc_parameters, "manage_default_vpc", false)

  create_igw = lookup(var.vpc_parameters, "create_igw", true)

  enable_dns_hostnames = lookup(var.vpc_parameters, "enable_dns_hostnames", true)
  enable_dns_support   = lookup(var.vpc_parameters, "enable_dns_support", true)

  map_public_ip_on_launch = lookup(var.vpc_parameters, "map_public_ip_on_launch", true)

  #nat gateway
  enable_nat_gateway     = lookup(var.vpc_parameters, "enable_nat_gateway", false)
  single_nat_gateway     = lookup(var.vpc_parameters, "single_nat_gateway", true)
  one_nat_gateway_per_az = lookup(var.vpc_parameters, "one_nat_gateway_per_az", false)

  # network_acl default config
  manage_default_network_acl    = lookup(var.vpc_parameters, "manage_default_network_acl", true)
  default_network_acl_tags      = lookup(var.vpc_parameters, "default_network_acl_tags", { Name = "${local.common_name}-default" })
  public_dedicated_network_acl  = lookup(var.vpc_parameters, "public_dedicated_network_acl", false) // ?
  public_inbound_acl_rules      = lookup(var.vpc_parameters, "public_inbound_acl_rules", [])
  public_outbound_acl_rules     = lookup(var.vpc_parameters, "public_outbound_acl_rules", [])
  private_dedicated_network_acl = lookup(var.vpc_parameters, "private_dedicated_network_acl", false) //?
  private_inbound_acl_rules     = lookup(var.vpc_parameters, "private_inbound_acl_rules", [])
  private_outbound_acl_rules    = lookup(var.vpc_parameters, "private_outbound_acl_rules", [])

  # route_table default config
  manage_default_route_table           = lookup(var.vpc_parameters, "manage_default_route_table", true)
  default_route_table_propagating_vgws = lookup(var.vpc_parameters, "default_route_table_propagating_vgws", [])
  default_route_table_routes           = lookup(var.vpc_parameters, "default_route_table_routes", [])
  default_route_table_tags             = lookup(var.vpc_parameters, "default_route_table_tags", { Name = "${local.common_name}-default" })


  # sg_default config
  manage_default_security_group  = lookup(var.vpc_parameters, "manage_default_security_group", true)
  default_security_group_ingress = lookup(var.vpc_parameters, "default_security_group_ingress", [])
  default_security_group_egress  = lookup(var.vpc_parameters, "default_security_group_egress", [])
  default_security_group_tags    = lookup(var.vpc_parameters, "default_security_group_tags", { Name = "${local.common_name}-default" })

  # vpn_gateway config
  enable_vpn_gateway                 = lookup(var.vpc_parameters, "enable_vpn_gateway", false)
  vpn_gateway_id                     = lookup(var.vpc_parameters, "vpn_gateway_id", "")
  vpn_gateway_az                     = lookup(var.vpc_parameters, "vpn_gateway_az", null)
  propagate_private_route_tables_vgw = lookup(var.vpc_parameters, "propagate_private_route_tables_vgw", false)
  propagate_public_route_tables_vgw  = lookup(var.vpc_parameters, "propagate_public_route_tables_vgw", false)

  # dhcp_options
  enable_dhcp_options               = lookup(var.vpc_parameters, "enable_dhcp_options", false)
  dhcp_options_domain_name          = lookup(var.vpc_parameters, "dhcp_options_domain_name", "")
  dhcp_options_domain_name_servers  = lookup(var.vpc_parameters, "dhcp_options_domain_name_servers", [])
  dhcp_options_ntp_servers          = lookup(var.vpc_parameters, "dhcp_options_ntp_servers", [])
  dhcp_options_netbios_name_servers = lookup(var.vpc_parameters, "dhcp_options_netbios_name_servers", [])
  dhcp_options_netbios_node_type    = lookup(var.vpc_parameters, "dhcp_options_netbios_node_type", "")


  # redshift
  enable_public_redshift = lookup(var.vpc_parameters, "enable_public_redshift", false)

  # flow_log config
  enable_flow_log                                 = lookup(var.vpc_parameters, "enable_flow_log", false)
  create_flow_log_cloudwatch_iam_role             = lookup(var.vpc_parameters, "create_flow_log_cloudwatch_iam_role", false)
  create_flow_log_cloudwatch_log_group            = lookup(var.vpc_parameters, "create_flow_log_cloudwatch_log_group", false)
  vpc_flow_log_permissions_boundary               = lookup(var.vpc_parameters, "vpc_flow_log_permissions_boundary", null)
  flow_log_traffic_type                           = lookup(var.vpc_parameters, "flow_log_traffic_type", "")
  flow_log_destination_type                       = lookup(var.vpc_parameters, "flow_log_destination_type", "")
  flow_log_log_format                             = lookup(var.vpc_parameters, "flow_log_log_format", null)
  flow_log_destination_arn                        = lookup(var.vpc_parameters, "flow_log_destination_arn", "")
  flow_log_cloudwatch_iam_role_arn                = lookup(var.vpc_parameters, "enable_public_redshift", "")
  flow_log_cloudwatch_log_group_name_prefix       = lookup(var.vpc_parameters, "flow_log_cloudwatch_log_group_name_prefix", "")
  flow_log_cloudwatch_log_group_retention_in_days = lookup(var.vpc_parameters, "flow_log_cloudwatch_log_group_retention_in_days", null)
  flow_log_cloudwatch_log_group_kms_key_id        = lookup(var.vpc_parameters, "flow_log_cloudwatch_log_group_kms_key_id", null)
  flow_log_max_aggregation_interval               = lookup(var.vpc_parameters, "flow_log_max_aggregation_interval", 600)
  flow_log_hive_compatible_partitions             = lookup(var.vpc_parameters, "flow_log_hive_compatible_partitions", false)
  flow_log_per_hour_partition                     = lookup(var.vpc_parameters, "flow_log_per_hour_partition", false)

  # Elasticache config
  create_elasticache_subnet_group       = lookup(var.vpc_parameters, "create_elasticache_subnet_group", false)
  elasticache_subnet_group_name         = lookup(var.vpc_parameters, "elasticache_subnet_group_name", null)
  elasticache_subnet_group_tags         = lookup(var.vpc_parameters, "elasticache_subnet_group_tags", {})
  create_elasticache_subnet_route_table = lookup(var.vpc_parameters, "create_elasticache_subnet_route_table", false)
  elasticache_route_table_tags          = lookup(var.vpc_parameters, "elasticache_route_table_tags", {})
  elasticache_dedicated_network_acl     = lookup(var.vpc_parameters, "elasticache_dedicated_network_acl", false) // ?
  elasticache_inbound_acl_rules         = lookup(var.vpc_parameters, "elasticache_inbound_acl_rules", [])
  elasticache_outbound_acl_rules        = lookup(var.vpc_parameters, "elasticache_outbound_acl_rules", [])
  elasticache_acl_tags                  = lookup(var.vpc_parameters, "elasticache_acl_tags", {})

  # DB config
  create_database_internet_gateway_route = lookup(var.vpc_parameters, "create_database_internet_gateway_route", false)
  create_database_nat_gateway_route      = lookup(var.vpc_parameters, "create_database_nat_gateway_route", false)
  create_database_subnet_group           = lookup(var.vpc_parameters, "create_database_subnet_group", false)
  database_subnet_group_name             = lookup(var.vpc_parameters, "database_subnet_group_name", "")
  create_database_subnet_route_table     = lookup(var.vpc_parameters, "create_database_subnet_route_table", false)
  database_dedicated_network_acl         = lookup(var.vpc_parameters, "database_dedicated_network_acl", false) // ?
  database_inbound_acl_rules             = lookup(var.vpc_parameters, "database_inbound_acl_rules", [])
  database_outbound_acl_rules            = lookup(var.vpc_parameters, "database_outbound_acl_rules", [])
  database_acl_tags                      = lookup(var.vpc_parameters, "database_acl_tags", {})

  tags = local.common_tags
}

module "vpc-endpoint" {
  source  = "terraform-aws-modules/vpc/aws//modules/vpc-endpoints"
  version = "3.18.1"

  vpc_id             = module.vpc.vpc_id
  security_group_ids = [data.aws_security_group.default.id]

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.s3_endpoint_policy.json
      tags            = { Name = "${local.common_name}-s3-vpc-endpoint" }
    },
    dynamodb = {
      service         = "dynamodb"
      service_type    = "Gateway"
      route_table_ids = flatten([module.vpc.intra_route_table_ids, module.vpc.private_route_table_ids, module.vpc.public_route_table_ids])
      policy          = data.aws_iam_policy_document.dynamodb_endpoint_policy.json
      tags            = { Name = "${local.common_name}-dynamodb-vpc-endpoint" }
    },
  }

  tags = local.common_tags
}

module "vpc-ec2-nat-gateway" {
  source = "./modules/aws/terraform-aws-vpc-ec2-nat-gateway"
  # Condition to Enable:
  # enable_ec2_nat_gateway = true
  # enable_nat_gateway = false
  create = lookup(var.vpc_parameters, "enable_ec2_nat_gateway", false) && !lookup(var.vpc_parameters, "enable_nat_gateway", false) ? true : false

  name = "${local.common_name}-natgw"

  vpc_id            = module.vpc.vpc_id
  route_table_id    = tolist(module.vpc.private_route_table_ids)[0]
  availability_zone = element(module.vpc.azs, 0)
  subnet_id         = element(module.vpc.public_subnets, 0)

  attach_eip = lookup(var.vpc_parameters, "ec2_nat_gateway_attach_eip", false)

  tags = local.common_tags
}