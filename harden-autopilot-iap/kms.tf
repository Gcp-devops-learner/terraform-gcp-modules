/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

data "google_project" "project" {}

locals {
gke_sa = "serviceAccount:service-${data.google_project.project.number}@container-engine-robot.iam.gserviceaccount.com"
}

module "kms" {
  source  = "terraform-google-modules/kms/google"
  version = "~> 2.2.1"
  project_id              = var.project_id
  location                = var.region
  keyring                 = var.keyring
  keys                    = var.keys
  prevent_destroy         = false
  set_decrypters_for      = var.keys
  set_encrypters_for      = var.keys
  encrypters = [
   local.gke_sa,
  ]
  decrypters = [
    local.gke_sa,
  ]
  depends_on              = [google_project_service.all]
}
