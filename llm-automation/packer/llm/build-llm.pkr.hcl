build {
    name = "llm-ami"
    sources = ["source.amazon-ebs.llm-linux"]

    provisioner "ansible" {
        playbook_file = "ansible/llm.yml"
    }
}