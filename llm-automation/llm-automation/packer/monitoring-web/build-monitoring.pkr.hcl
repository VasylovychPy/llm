build {
    name = "monitoring-ami"
    sources = ["source.amazon-ebs.monitoring-linux"]

    provisioner "ansible" {
        playbook_file = "ansible/monitoring.yml"
    }
}
