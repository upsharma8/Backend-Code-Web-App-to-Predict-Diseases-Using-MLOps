
# Kubernetes_Master Launching
resource "aws_instance" "k8-master" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "upmanyu_key"
   availability_zone = "ap-south-1a"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   
  tags = {
    Name = "Kubernete_Master"
  }
}
# Kubernetes_Slave1 Launching
resource "aws_instance" "k8-slave1" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "upmanyu_key"
   availability_zone = "ap-south-1a"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   
  tags = {
    Name = "Kubernete_Slave1"
  }
}
# Kubernetes_Slave1 Launching
resource "aws_instance" "k8-slave2" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "upmanyu_key"
   availability_zone = "ap-south-1a"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   
  tags = {
    Name = "Kubernete_Slave2"
  }
}
# Kubernetes_Slave1 Launching
resource "aws_instance" "jenkins-server" {
   ami  = "${var.ami}"
   instance_type = "t2.micro"
   key_name = "upmanyu_key"
   availability_zone = "ap-south-1a"
   subnet_id = "${aws_subnet.public-subnet.id}"
   vpc_security_group_ids = ["${aws_security_group.sgweb.id}"]
   associate_public_ip_address = true
   
  tags = {
    Name = "jenkins_server"
  }
}
  

output "instance_ip_addr" {
  value = aws_instance.k8-master.public_ip
}
output "instance_ip_addr1" {
  value = aws_instance.k8-slave1.public_ip
}
output "instance_ip_addr2" {
  value = aws_instance.k8-slave2.public_ip
}


resource "null_resource" "runcommands" {
connection {
    type     = "ssh"
    user     = "root"
    password = "upmanyu9"
    host     = "192.168.29.186"
  }

provisioner "remote-exec" { 

    inline = [
     
      "echo [master] > /ansible_roles/kube-role/ip1.txt",
      "echo ${aws_instance.k8-master.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/root/upmanyu_key.pem >> /ansible_roles/kube-role/ip1.txt",
      "echo [slave] >> /ansible_roles/kube-role/ip1.txt",
      "echo ${aws_instance.k8-slave1.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/root/upmanyu_key.pem >> /ansible_roles/kube-role/ip1.txt",
      "echo ${aws_instance.k8-slave2.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file=/root/upmanyu_key.pem >> /ansible_roles/kube-role/ip1.txt",
      
      "cd /ansible_roles/kube-role/;ansible-playbook kubernete-role.yml",
    
    ]
}
}