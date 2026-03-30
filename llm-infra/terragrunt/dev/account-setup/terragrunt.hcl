terraform {
  source = "../../../account-setup"

  extra_arguments "vars" {
    commands = get_terraform_commands_that_need_vars()

    arguments = [
      "-var-file=workspace_vars/dev-01.tfvars"
    ]
  }

  before_hook "workspace" {
    commands = ["plan", "apply", "destroy", "state"]

    execute = [
      "bash",
      "-c",
      "terraform workspace select -or-create dev-01"
    ]
  }
}