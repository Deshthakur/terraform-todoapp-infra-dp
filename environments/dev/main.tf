locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "desh"
  }
}


module "rg" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-desh-todoapp-01"
  rg_location = "west us"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrdeshtodoapp01"
  rg_name    = "rg-desh-todoapp-01"
  location   = "west us"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../../modules/azurerm_sql_server"
  sql_server_name = "sql-desh-todoapp-01"
  rg_name         = "rg-desh-todoapp-01"
  location        = "west us"
  admin_username  = "deshopsadmin"
  admin_password  = "P@ssw01rd@123"
  tags            = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-desh-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = local.common_tags
}

module "aks" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_kubernetes_cluster"
  aks_name   = "aks-desh-todoapp"
  location   = "west us"
  rg_name    = "rg-desh-todoapp-01"
  dns_prefix = "aks-desh-todoapp"
  tags       = local.common_tags
}


module "pip" {
  source   = "../../modules/azurerm_public_ip"
  pip_name = "pip-desh-todoapp"
  rg_name  = "rg-desh-todoapp-01"
  location = "west us"
  sku      = "Standard"
  tags     = local.common_tags
}
