build {
    name = "llm-ami"
    sources = ["source.amazon-ebs.llm-linux"]

    provisioner "shell" {
        script = "scripts/ollama-setup.sh"
    }

}