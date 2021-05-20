module "vpcssh" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-vpc-ssh.git"

  resource_group_name = module.resource_group.name
  region              = var.region
  name_prefix         = "vpc-test-ssh"
  ibmcloud_api_key    = var.ibmcloud_api_key
  public_key          = ""
  private_key         = ""
}
