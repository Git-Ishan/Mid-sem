output "user_data_script" {
  description = "The base64-encoded user data script to configure the NGINX app."
  value       = base64encode(file("${path.module}/user_data.sh"))
}