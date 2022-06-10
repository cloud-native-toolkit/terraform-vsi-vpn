module "vpcssh" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpc-ssh.git"

  resource_group_name = module.resource_group.name
  name_prefix         = "vpc-test-ssh"
  public_key          = ""
  private_key         = ""
}
