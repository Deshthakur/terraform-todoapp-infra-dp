locals {
  common_tags = {
    "ManagedBy"   = "Terraform"
    "Owner"       = "TodoAppTeam"
    "Environment" = "dp"
  }
}


module "rg" {
  source      = "../../modules/azurerm_resource_group"
  rg_name     = "rg-dp-todoapp-01"
  rg_location = "centralindia"
  rg_tags     = local.common_tags
}

module "acr" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_container_registry"
  acr_name   = "acrdptodoapp01"
  rg_name    = "rg-dp-todoapp-01"
  location   = "centralindia"
  tags       = local.common_tags
}

module "sql_server" {
  depends_on      = [module.rg]
  source          = "../../modules/azurerm_sql_server"
  sql_server_name = "sql-dp-todoapp-01"
  rg_name         = "rg-dp-todoapp-01"
  location        = "centralindia"
  admin_username  = "dpopsadmin"
  admin_password  = "P@ssw01rd@123"
  tags            = local.common_tags
}

module "sql_db" {
  depends_on  = [module.sql_server]
  source      = "../../modules/azurerm_sql_database"
  sql_db_name = "sqldb-dp-todoapp"
  server_id   = module.sql_server.server_id
  max_size_gb = "2"
  tags        = local.common_tags
}

module "aks" {
  depends_on = [module.rg]
  source     = "../../modules/azurerm_kubernetes_cluster"
  aks_name   = "aks-dp-todoapp"
  location   = "centralindia"
  rg_name    = "rg-dp-todoapp-01"
  dns_prefix = "aks-dp-todoapp"
  tags       = local.common_tags
}


module "pip" {
  source   = "../../modules/azurerm_public_ip"
  pip_name = "pip-dp-todoapp"
  rg_name  = "rg-dp-todoapp-01"
  location = "centralindia"
  sku      = "Basic"
  tags     = local.common_tags
}
