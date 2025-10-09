<h2>Configuration Structure</h2>

To ensure scalability and maintainability, the repository follows a structured format:

<img width="263" height="505" alt="1" src="https://github.com/user-attachments/assets/36ea8c28-f241-4fc8-a7b2-88ee6c63179a" />


This repository uses a standard modular structure to keep the code organized and reusable.

The modules directory contains the core, reusable building blocks for the infrastructure, such as networking, compute (for the virtual machines), and the loadbalancer.

The environments directory contains a separate folder for each deployment target (e.g., dev). These folders are responsible for assembling the building blocks from the modules directory and providing environment-specific settings.

The root of the repository holds global files that apply to the whole project, like versions.tf and the CI/CD pipeline definitions.


<img width="1117" height="679" alt="2" src="https://github.com/user-attachments/assets/9fec8c7f-91af-40b3-b0f8-1c93b1a53d2a" />

<img width="1117" height="682" alt="3" src="https://github.com/user-attachments/assets/a5d82f5a-aca8-4c88-838f-c21fea53b540" />

<img width="1120" height="682" alt="4" src="https://github.com/user-attachments/assets/0fada871-6d0c-4291-8ba2-358278202727" />

    Implementation in Jenkins
    For this project, Jenkins was installed and configured as a controller node directly on a Windows machine.
    To allow Jenkins to authenticate with Azure, an Azure Service Principal was created using the Azure CLI, and its JSON credential was stored securely within Jenkins's Credentials Manager as 'Secret Text'.
    The virtual machine's administrator password was also stored as a separate secret credential to ensure no sensitive information was exposed in the pipeline logs.
    A key part of the implementation was adapting the Jenkinsfile to run on a Windows-based agent by converting all shell (sh) commands to their batch (bat) equivalents.

Jenkins Pipeline Flow

The `Jenkinsfile` defines a parameterized pipeline, allowing the user to select the target **environment** (e.g., `dev`) and choose whether to apply changes.

The pipeline begins by authenticating to Azure using the stored Service Principal. It then navigates into the selected environment's directory to execute the standard Terraform workflow: `terraform init` to prepare the workspace, followed by `terraform plan -out=tfplan` to generate a plan file. This plan is saved as a build artifact for review.

A manual approval gate then pauses the pipeline, ensuring no changes are applied without explicit consent. If approved, the final stage executes `terraform apply` on the saved plan file, ensuring a controlled and predictable deployment.

<img width="2220" height="1230" alt="image" src="https://github.com/user-attachments/assets/03f65b4b-20b7-4710-8007-3943d683db81" />

<img width="555" height="791" alt="image" src="https://github.com/user-attachments/assets/c5c62f19-656e-4b54-979f-15841ea44c3d" />

<img width="1112" height="601" alt="jenkins1" src="https://github.com/user-attachments/assets/96195f6f-d624-4ff2-bfbe-a59a084fd311" />

<img width="1118" height="607" alt="jenkins2" src="https://github.com/user-attachments/assets/896a1f84-15ee-478d-9ca5-6edc25449e80" />


    Implementation in Azure Pipelines
    The Azure DevOps pipeline is defined declaratively in the azure-pipelines.yml file.
    Authentication is managed through a Service Connection (named azure-terraform-connection in this project) created in the Project Settings.
    This securely handles all permissions and eliminates the manual JSON credential handling required by Jenkins. 
    Other secrets, like the virtual machine's admin_password, are stored as Pipeline Secret Variables to ensure they are never exposed in logs.


The `azure-pipelines.yml` file defines a two-stage process that runs on a self-hosted agent. The **Plan** stage first installs Terraform, then runs `terraform init` to prepare the project. Afterwards, it executes `terraform plan`, using a secret variable for the VM password, and saves the resulting `tfplan` file as a pipeline artifact.

The **Apply** stage then begins by downloading the `tfplan` artifact from the previous stage. It runs `terraform init` again to set up the environment and finally executes `terraform apply` on the downloaded plan, ensuring that only the exact changes reviewed in the plan are deployed to Azure.

<img width="1120" height="503" alt="yaml final" src="https://github.com/user-attachments/assets/da9135ff-4fbc-473c-9c51-baf0e2ba65ae" />

<img width="320" height="595" alt="last" src="https://github.com/user-attachments/assets/32855d89-683e-4d48-af76-7240c737e32e" />

<img width="1112" height="613" alt="yaml pipeline" src="https://github.com/user-attachments/assets/cdb9e6c6-16db-40ce-8ec3-1abbe0ff4274" />


## 📖 My Journey & Key Learnings

This project was a significant learning experience involving extensive real-world troubleshooting:

* **Cross-Platform Challenges:** The project was initially attempted on Linux and later transitioned to a fresh Windows environment, which required debugging `PATH` variable issues for tools like the Azure CLI and Docker.
* **Terraform Debugging:** I encountered and solved a wide variety of Terraform errors, from simple typos and inconsistent dependency lock files (`terraform init -upgrade`) to complex state file corruption that required manual resource deletion in Azure.
* **CI/CD Troubleshooting:** Setting up the pipelines involved challenges like installing missing Marketplace extensions in Azure DevOps, configuring a self-hosted agent to bypass free tier limitations, and fixing permissions by correctly assigning IAM roles (`Contributor`) to the Service Principal.
* **Git Repository Management:** A key lesson was realizing a missing `.gitignore` file caused the repository to bloat to over 100MB. I learned to clean the repository history using commands like `git rm --cached`, `git reset`, and `git push --force`.
