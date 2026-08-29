config {
  format              = "compact"
  call_module_type    = "local"
  force               = false
  disabled_by_default = false
}

# Enables standard terraform rules
plugin "terraform" {
  enabled = true
  preset  = "recommended"
}
