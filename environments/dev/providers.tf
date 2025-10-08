terraform {}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = "5d228b2b-b879-4a16-a9a9-d0ceb7f20fe4"
}