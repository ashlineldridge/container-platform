resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.control_plane_role.arn

  vpc_config {
    subnet_ids = var.cluster_subnet_ids
    security_group_ids = [aws_security_group.control_plane_security_group.id]
  }
}

resource "aws_iam_role" "control_plane_role" {
  name = "${var.cluster_name}-control-plane-role"

  assume_role_policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Effect": "Allow"
      }
    ]
  }
  EOT
}

resource "aws_iam_role_policy_attachment" "service_policy_attachment" {
  role       = "${aws_iam_role.control_plane_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_policy_attachment" {
  role       = "${aws_iam_role.control_plane_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_security_group" "control_plane_security_group" {
  name        = "${var.cluster_name}-control-plane-security-group"
  description = "Cluster communication with worker nodes"
  vpc_id      = var.cluster_vpc_id
}


output "kubeconfig-certificate-authority-data" {
  value = "${aws_eks_cluster.cluster.certificate_authority.0.data}"
}
