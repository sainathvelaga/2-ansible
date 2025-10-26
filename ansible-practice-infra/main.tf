resource "aws_instance" "ansible_hosts" {
  count         = var.instance_count
  ami           = data.aws_ami.ami_info.id
  instance_type = var.instance_type
  security_groups = [aws_security_group.ansible_sg.name]
  user_data = count.index == 0 ? file("${path.module}/ansible.sh") : ""
  tags = {
    Name = count.index == 0 ? "Ansible-Master" : "Ansible-Node-${count.index}"
  }
}

resource "aws_security_group" "ansible_sg" {
  name        = "ansible-sg"
  description = "Allow SSH"
  vpc_id      = "vpc-0397e518ad9248894" # replace with your VPC ID

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 2.0"

  zone_name = data.aws_route53_zone.sainathdevops.name

  records = [
    {
      name    = "ansible-master"
      type    = "A"
      ttl     = 1
      records = [
        aws_instance.ansible_hosts[0].public_ip
      ]
      allow_overwrite = true
    },
    {
      name    = "ansible-node"
      type    = "A"
      ttl     = 1
      records = [
        aws_instance.ansible_hosts[1].private_ip
      ]
      allow_overwrite = true
    }
  ]

}