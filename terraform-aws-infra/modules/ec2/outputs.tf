output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}

output "private_ip" {
  value = aws_instance.this.private_ip
}

output "key_pair_name" {
  value = aws_key_pair.ec2_key_pair.key_name
}

output "private_key_path" {
  value     = local_file.private_key.filename
  sensitive = true
}