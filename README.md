# mc_clusters
Magic castle cluster configurations for bootcamps.

# Structure of this repository
Directories are named after specific workshops. Each directory contains a Magic Castle configuration in the form of a main.tf and config.yaml files. .tf file defines the typical openstack and dns modules. config.yaml file is used to define the puppet yaml configurations. Finally, sshkeys.pub file inside the keys folder contains public SSH keys which will be injected into the resulting clusters.


