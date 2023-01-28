provider "aws" {
	access_key = "=========================="
	secret_key = "=========================="
	region = "ap-south-1"
}
resource "aws_instance" "myUbuntuServer" {
	ami = "ami-0f69bc5520884278e"
	instance_type = "t2.micro"
	key_name = "KeyPairJan2022"
	vpc_security_group_ids = ["sg-0d23fef751c6f316a"]
  	tags = {
		"Name" = "myUbuntuServer"
	}
	connection { 
		type = "ssh"
		user = "ubuntu"
		private_key = "${file("KeyPairJan2022.pem")}"
		host = aws_instance.myUbuntuServer.public_ip
		agent = false
		timeout = "300s"
	}

	provisioner "remote-exec" {
		inline = [
			"sudo apt-get update",
			"sudo apt-get install apache2 -y",
			"sudo systemctl start apache2",
			"sudo systemctl enable apache2"
		]
    
	}	
}
output "myUbuntuServer_ip" { value = aws_instance.myUbuntuServer.public_ip }
