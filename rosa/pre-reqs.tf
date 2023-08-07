resource "terraform_data" "reqs" {
  provisioner "local-exec" {
    command = "./pre-reqs.sh"
  }
}
