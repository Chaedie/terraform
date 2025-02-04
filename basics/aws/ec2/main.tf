resource "aws_instance" "webserver" {
  ami = "ami-0edab43b6fa892279"
  instance_type = "t2.micro"
  tags = {
    Name = "webserver"
    Description = "An Nginx Webserver on Ubuntu simple web server"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              systemctl enable nginx
              systemctl start nginx
              EOF
  key_name = aws_key_pair.webserver-key.id
  vpc_security_group_ids = [ aws_security_group.ssh-access.id ]
} 

resource "aws_key_pair" "webserver-key" {
  key_name = "webserver-key"
  public_key = file("~/.ssh/web.pub")
}

resource "aws_security_group" "ssh-access" {
  name = "ssh-access"
  description = "Allow SSH access from the Internet"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output publicip {
  value = aws_instance.webserver.public_ip
}