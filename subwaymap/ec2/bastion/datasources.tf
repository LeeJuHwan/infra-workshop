data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../vpc/infraworkshop-apne2/terraform.tfstate"
  }
}
