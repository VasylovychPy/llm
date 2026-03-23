build {
    name = "bastion-ami"
    sources = ["source.amazon-ebs.bastion-linux"]

    provisioner "shell" {
        script = "scripts/base-tools.sh"
    }

}