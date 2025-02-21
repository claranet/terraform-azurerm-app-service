output "module_container" {
  description = "App Service Container (Container WebApp) output object if Container is choosen. Please refer to `./modules/container-web-app/README.md`"
  value       = one(module.container_web_app[*])
}

output "module_linux" {
  description = "App Service Linux (Linux WebApp) output object if Linux is choosen. Please refer to `./modules/linux-web-app/README.md`"
  value       = one(module.linux_web_app[*])
}

output "module_windows" {
  description = "App Service Windows (Windows WebApp) output object if Windows is choosen. Please refer to `./modules/windows-web-app/README.md`"
  value       = one(module.windows_web_app[*])
}
