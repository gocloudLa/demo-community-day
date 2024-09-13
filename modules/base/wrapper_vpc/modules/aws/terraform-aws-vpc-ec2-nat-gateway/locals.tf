locals {

  user_data = templatefile("${path.module}/template/user_data.tpl", {
    vpc_cidr_block = try(data.aws_vpc.this[0].cidr_block, "")
  })

}