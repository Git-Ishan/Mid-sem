<h2>Configuration Structure</h2>

To ensure scalability and maintainability, the repository follows a structured format:

<img width="263" height="505" alt="1" src="https://github.com/user-attachments/assets/36ea8c28-f241-4fc8-a7b2-88ee6c63179a" />


Repository Root contains global configuration files like versions.tf.
  Environments Directory holds isolated folders for each environment (e.g., environments/dev) with their own main.tf, variables.tf, and state files, allowing environment-specific configurations.
Modules Directory includes reusable Terraform modules such as networking, compute, loadbalancer, and nginx. Each module has its own main.tf, variables.tf, and outputs.tf, making the setup modular and easy to manage.


<img width="1117" height="679" alt="2" src="https://github.com/user-attachments/assets/9fec8c7f-91af-40b3-b0f8-1c93b1a53d2a" />

<img width="1117" height="682" alt="3" src="https://github.com/user-attachments/assets/a5d82f5a-aca8-4c88-838f-c21fea53b540" />

<img width="1120" height="682" alt="4" src="https://github.com/user-attachments/assets/0fada871-6d0c-4291-8ba2-358278202727" />

    Implementation in Jenkins
    Jenkins is configured as a controller node with the required Pipeline Utility Steps Plugin, along with Git and Azure CLI for automation.
    For Azure authentication, Service Principal credentials (Client ID, Secret, Tenant ID, Subscription ID) are stored securely in Jenkins using the Credentials Manager as a single JSON “Secret Text”. A Groovy script then parses these values and runs the az login --service-principal command.
    Other sensitive details, like VM administrator passwords, are also stored as Secret Text credentials and are masked in the pipeline logs for security.

Jenkins Pipeline Flow

The Groovy-based Jenkinsfile automates the Terraform workflow.
The Environment Setup stage defines all secrets using credentials().
The Azure Login Stage authenticates to Azure CLI using a Service Principal.
The Terraform Init Stage runs terraform init -upgrade inside the environment directory (e.g., environments/dev).
The Terraform Plan Stage executes terraform plan -out=tfplan, generating the plan file.
The Terraform Apply Stage runs only if APPLY_CHANGES is true, applying the plan using terraform apply -auto-approve tfplan.

The pipeline ensures secure credentials handling, clear separation of stages, and controlled deployment execution.

<img width="2220" height="1230" alt="image" src="https://github.com/user-attachments/assets/03f65b4b-20b7-4710-8007-3943d683db81" />

<img width="555" height="791" alt="image" src="https://github.com/user-attachments/assets/c5c62f19-656e-4b54-979f-15841ea44c3d" />

<img width="1112" height="601" alt="jenkins1" src="https://github.com/user-attachments/assets/96195f6f-d624-4ff2-bfbe-a59a084fd311" />

<img width="1118" height="607" alt="jenkins2" src="https://github.com/user-attachments/assets/896a1f84-15ee-478d-9ca5-6edc25449e80" />


    Implementation in Azure Pipelines
    Azure Pipelines uses a declarative YAML file (azure-pipelines.yml) and leverages built-in Azure DevOps authentication.
    A Service Connection (e.g., meowmeow) is created under Project Settings using Azure Resource Manager, securely storing Service Principal credentials and permissions — eliminating the need for manual JSON credential handling as in Jenkins.
    Sensitive data such as the admin password is stored as Pipeline Secret Variables, ensuring secure and seamless access during Terraform operations.


Azure Pipelines YAML Flow

The YAML file defines multiple stages executed on a Linux-based agent.
The PrepareAndPlan stage installs the required Terraform version using the TerraformInstaller task, logs in via the AzureCLI task using the configured Service Connection, and runs terraform init, validate, and plan to generate the tfplan artifact.
The DeploymentApproval stage serves as a manual gate, typically tied to an Azure Environment with an Approval Check, ensuring a team member reviews and approves the plan before deployment.
Finally, the ApplyDeployment stage runs only after successful completion and approval, executing terraform apply -auto-approve tfplan to implement the approved infrastructure changes.

<img width="1120" height="503" alt="yaml final" src="https://github.com/user-attachments/assets/da9135ff-4fbc-473c-9c51-baf0e2ba65ae" />

<img width="320" height="595" alt="last" src="https://github.com/user-attachments/assets/32855d89-683e-4d48-af76-7240c737e32e" />

<img width="1112" height="613" alt="yaml pipeline" src="https://github.com/user-attachments/assets/cdb9e6c6-16db-40ce-8ec3-1abbe0ff4274" />
