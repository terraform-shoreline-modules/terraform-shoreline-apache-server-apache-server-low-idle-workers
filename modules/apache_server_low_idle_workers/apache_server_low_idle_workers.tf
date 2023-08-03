resource "shoreline_notebook" "apache_server_low_idle_workers" {
  name       = "apache_server_low_idle_workers"
  data       = file("${path.module}/data/apache_server_low_idle_workers.json")
  depends_on = [shoreline_action.invoke_apache_status_check]
}

resource "shoreline_file" "apache_status_check" {
  name             = "apache_status_check"
  input_file       = "${path.module}/data/apache_status_check.sh"
  md5              = filemd5("${path.module}/data/apache_status_check.sh")
  description      = "Higher than normal traffic on the web server causing a higher number of requests and a lower number of idle workers."
  destination_path = "/agent/scripts/apache_status_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_status_check" {
  name        = "invoke_apache_status_check"
  description = "Higher than normal traffic on the web server causing a higher number of requests and a lower number of idle workers."
  command     = "`chmod +x /agent/scripts/apache_status_check.sh && /agent/scripts/apache_status_check.sh`"
  params      = ["MAX_IDLE_WORKERS","APACHE_STATUS_URL"]
  file_deps   = ["apache_status_check"]
  enabled     = true
  depends_on  = [shoreline_file.apache_status_check]
}

