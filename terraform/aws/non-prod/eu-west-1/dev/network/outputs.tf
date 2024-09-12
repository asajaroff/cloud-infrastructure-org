output public_subnets {
  value       = aws_subnet.public[0].id
  sensitive   = false
  description = "A public subnet from the network module"
}

output sg_allow_ssh {
    value = aws_security_group.allow_ssh.id
    sensitive = false
    description = "Allows SSH in and all outbound traffic"
}