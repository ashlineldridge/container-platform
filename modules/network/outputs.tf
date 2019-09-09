output "vpc_id" {
  value = aws_vpc.cluster_vpc.id
}

output "subnet_ids" {
  value = [
    aws_subnet.public_subnet_a,
    aws_subnet.public_subnet_b,
    aws_subnet.public_subnet_c,
    aws_subnet.private_subnet_a,
    aws_subnet.private_subnet_b,
    aws_subnet.private_subnet_c,
  ]
}
