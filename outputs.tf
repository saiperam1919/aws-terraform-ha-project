output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}