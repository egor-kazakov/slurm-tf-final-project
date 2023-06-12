resource "yandex_iam_service_account" "this" {
  name        = "sa"
  description = "service account to manage PVC"
  folder_id = var.YC_FOLDER_ID
}

resource "yandex_resourcemanager_folder_iam_binding" "this" {
  folder_id = var.YC_FOLDER_ID
  role = "editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.this.id}",
  ]
}