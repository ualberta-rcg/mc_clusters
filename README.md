# mc_clusters
Magic castle cluster configurations for bootcamps.

# Structure of this repository
Directories are named after specific workshops. Each directory contains a Magic Castle configuration in the form of a main.tf and config.yaml files. .tf file defines the typical openstack and dns modules. config.yaml file is used to define the puppet yaml configurations. Finally, sshkeys.pub file inside the keys folder contains public SSH keys which will be injected into the resulting clusters.


# Create variable sets
Variable sets can be assigned one of three scopes to determine which workspaces use the variables they contain. 
- Organization: The variable set applies automatically to all current and future workspaces within the organization.
- Project-specific: The variable set automatically applies to all current and future workspaces within one or more specific projects. 
- Workspace-specific: The variable set applies only to a specific list of selected workspaces. 

Three variable sets are already defined in the organization scope.
1. Cloudflare
2. Arbutus Training Project
3. Beluga Training Project

## Create Openstack variable set

Add the created openstack application credential to the following terraform variables with keys in the  "Environment variable" category and ensuring that the "Sensitive" box is checked:
- OS_APPLICATION_CREDENTIAL_ID : Application credential ID 
- OS_APPLICATION_CREDENTIAL_SECRET : Application credential secret
- OS_AUTH_TYPE which has the value "v3applicationcredential"

Set the following variables values equal to those defined in the openstack rc file ofthe project. These variables as above, should be in the “Environment variable” category but need not be secret.
- OS_AUTH_URL
- OS_IDENTITY_API_VERSION
- OS_INTERFACE
- OS_REGION_NAME

## Create cloudflare variable set

Add the created cloudflare API token string to the following terraform variables with keys in the  "Environment variable" category and ensuring that the "Sensitive" box is checked:
- CLOUDFLARE_API_TOKEN
- CLOUDFLARE_DNS_API_TOKEN
- CLOUDFLARE_ZONE_API_TOKEN

# Associate github repo with terraform cloud

1. Go to https://app.terraform.io/login and sign in
2. Under "Projects & workspaces" click "new" and "workspace"
3. Select "Default Project" and click "create"
4. Select "Version control workflow"
5. Select "GitHub App"
6. Select git repository, select the "mc-clusters" repository
7. Under "Advanced options" set "Terraform Working Directory" to "<cluster-name>/", which corresponds to the directory in the mc-clusters repository with the main.tf file for the cluster
8. Select "Auto-apply API, CLI & VCS runs"
9. Under "VCS Triggers" select "Only trigger runs when files in specified paths change"
10. Then for the "Path" text box enter "<cluster-name>/*" and click "Add pattern"
11. Click "Create" to create the workspace
12. Click on Variables on the left hand menu for the newly created workspace. Under Variable sets click "Apply variable set"
13. In the drop down select which cloud project is used to create the cluster.
14. Click "apply variable set"
15. In the drop down select "cloudflare"
16. Click "apply variable set"

