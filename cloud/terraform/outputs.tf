output "ec2_cvpdfviewer_id" {
    description = "id of the cvpdfviewer ec2 instance"
    value = aws_instance.ec2_cvpdfviewer.id
}

output "instance_ip" {
    description = "public ip of the cvpdfviewer ec2 instance"
    value = aws_instance.ec2_cvpdfviewer.public_ip
}