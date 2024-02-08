locals {
  web_inbound_ports_map = {
    "110" : "443",
    "120" : "22"
  }
}

locals {
  db_inbound_ports_map = {
    "100" : "3306",
    "110" : "1433",
    "120" : "5432"
  }
}

locals {
  mw_inbound_ports_map = {
    "110" : "443",
    "120" : "22"
  }
}