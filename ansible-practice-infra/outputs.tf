output "ansible_master_ip" {
  value = aws_instance.ansible_hosts[0].public_ip
}

output "ansible_node-1_ip" {
  value = aws_instance.ansible_hosts[1].public_ip
}