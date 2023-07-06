resource "aws_instance" "sftp-server" {
  ami           = "ami-05432c5a0f7b1bfd0"  # Set your desired Amazon Machine Image (AMI)
  instance_type = "${var.instancetype}"  # Set your desired instance type
  key_name      = "${var.keypairname}"  # Set your key pair name
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.allow_ssh_sftp.id,aws_security_group.egress_full.id]
  iam_instance_profile = aws_iam_instance_profile.s3_sftp_profile.name
  provisioner "remote-exec" {

              inline = [
                      "sudo yum update -y",
                      "sudo yum install -y openssh-server cronie",
                      "sudo groupadd sftpusers",
                      "sudo sed -i 's/^Subsystem\\ssftp.*$/#Subsystem sftp \\/usr\\/libexec\\/openssh\\/sftp-server/' /etc/ssh/sshd_config",
                      "echo 'Subsystem       sftp    internal-sftp' | sudo tee -a /etc/ssh/sshd_config > /dev/null",
                      "echo 'Match group sftpusers' | sudo tee -a /etc/ssh/sshd_config > /dev/null",
                      "echo '   ChrootDirectory %h' | sudo tee -a /etc/ssh/sshd_config > /dev/null",
                      "echo '   ForceCommand internal-sftp' | sudo tee -a /etc/ssh/sshd_config > /dev/null",
                      "echo '   PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config > /dev/null",
                      "sudo systemctl restart sshd",
                      "sudo useradd ${var.sftp_user_name} -s /usr/sbin/nologin",
                      "echo ${var.sftp_password} | sudo passwd --stdin ${var.sftp_user_name}",
                      "sudo usermod -d /uploads/${var.sftp_user_name}/  ${var.sftp_user_name}",
                      "sudo mkdir -p /uploads/${var.sftp_user_name}/data",
                      "sudo chown root:sftpusers /uploads/${var.sftp_user_name}",
                      "sudo chown ${var.sftp_user_name}:sftpusers /uploads/${var.sftp_user_name}/data",
                      "sudo usermod -aG sftpusers ${var.sftp_user_name}",
                      "sudo chmod -R 755 /uploads/${var.sftp_user_name}/data",
                      "echo '*/30 * * * *   /usr/bin/ aws s3 sync /uploads/${var.sftp_user_name}/data  s3://${aws_s3_bucket.agency_bucket.id}/${var.sftp_user_name}' | sudo crontab -u root -"

      ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${var.key_location}")
      host        = self.public_ip
       }
    }
  }

  
// Profile link S3 Read Write Access to sftp server
resource "aws_iam_instance_profile" "s3_sftp_profile" {
  name = "s3_sftp_profile"
  role = aws_iam_role.s3_read_write_access_role.name
}
