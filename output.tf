output "vpc_id" {
  value = aws_vpc.CustomVPC.id
}

output "CustomPublicSubnet1" {
  value = aws_subnet.CustomPublicSubnet1.id
}

output "CustomPublicSubnet2" {
  value = aws_subnet.CustomPublicSubnet2.id
}

output "CustomPrivateSubnet1" {
  value = aws_subnet.CustomPrivateSubnet1.id
}

output "CustomPrivateSubnet2" {
  value = aws_subnet.CustomPrivateSubnet2.id
}


output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "rds_subnetgroup_id" {
  value = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_endpoint_name" {
  value = aws_db_instance.appdb.endpoint
}

output "alb_dns_name" {
  value = aws_lb.wordpress-alb.dns_name
}

output "alb_tg_arn" {
  value = aws_lb_target_group.wordpress_tg.arn
}