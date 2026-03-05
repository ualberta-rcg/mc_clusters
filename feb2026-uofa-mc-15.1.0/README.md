# This is a cluster for the Febuary 2026 workshops.

## Things to note

The heirdata in `config.yaml` defines a few things:

* It sets up the Jupyter interface to point to RStudio more easily.
* It sets up RStudio to use version 4.5 out of the box (to match the
  default R version on the cluster).
* It sets up default time limit in Jupyter to four hours.
* It sets up the number of failures in fail2ban to 100
  (up from the default of 20).
* It sets a `R_LIBS` environment variable for each user to the location
  `/project/def-sponsor00/R_4.5_LIBS`. The libraries for this location
  are created manually, see below.

## Here is how it is made

### Download Magic Castle for OpenStack

In my case, magic_castle-openstack-15.1.0.tar.gz.

Extract into a feb2026-uofa-mc-15.1.0 directory.

```
wget https://github.com/ComputeCanada/magic_castle/releases/download/15.1.0/magic_castle-openstack-15.1.0.tar.gz
tar xf magic_castle-openstack-15.1.0.tar.gz
mv magic_castle-openstack-15.1.0 feb2026-uofa-mc-15.1.0
```

### Copy the files from this repository over there.

In particular `main.tf` and `config.yaml`.
Check the section in `main.tf` and replace with whichever public
keys you want to permit.

### Stand up the cluster as usual with terraform.

You probably want to set up an ssh-agent first, then source your OpenStack and Cloudflare RC files.

Then:

```
terraform init
terraform plan
terraform apply -auto-approve
```

### Set up a user for your self.

Do the mokey/ipa steps, as usual. Your user will be a member of group
`def-sponsor00`.

Relevant URLs:

* mokey.feb2026-uofa.c3.ca
* ipa.feb2026-uofa.c3.ca

Info about the ipa password is below in the Misc section.

### Create the R library:

```
module load r/4.5
R
install.packages(c("tidyverse", "naniar", "coefplot", "broom"))
```

### Move the library to a shared location

In particular, the location specified by the `R_LIBS` environment variable.

```
cp -a ~/R/x86_64-pc-linux-gnu-library/4.5 /project/def-sponsor00/R_4.5_LIBS
cd /project/def-sponsor00
chmod o+rx R_4.5_LIBS
chgrp -R def-sponsor00 R_4.5_LIBS

# Make sure our local R stuff doesn't conflict with the shared stuff
rm -rf ~/R
```

## Test

How do we know this thing is doing what we want it to?

### Jupyter Hub

* Point your browser to feb2026-uofa.c3.ca
* After login, the job launcher should should have an RStudio choice.
* Worst case, you might have to launch a JupyterLab and hopefully the
  launcher there will have RStudio
* When RStudio starts, it should say version 4.5
* If you type `Sys.getenv()` it should contain the `R_LIBS` variable
  mentioned above.
* It should not fail when you type `library('tidyverse')`. You will
  likely get a message about some conflicts though, they are fine.
* There are other libs that were installed, you can test them too.

### Command Line

* Do `module load r/4.5.0`
* Type `R`
* It should not fail when you type `library('tidyverse')`. You will
  likely get a message about some conflicts though, they are fine.

## Misc.

See entry in reservation spreadsheet:
<https://docs.google.com/spreadsheets/d/1u0IcuA595lB36MN_EkKK9bTF_kj6utXXNBX0mNBQQc8/edit?gid=0#gid=0>

Getting the admin password for ipa (as account `centos`):

```
ssh mgmt1
sudo /opt/puppetlabs/puppet/bin/eyaml edit --pkcs7-private-key /etc/puppetlabs/puppet/eyaml/boot_private_key.pkcs7.pem --pkcs7-public-key /etc/puppetlabs/puppet/eyaml/boot_public_key.pkcs7.pem /etc/puppetlabs/code/environments/production/data/bootstrap.yaml
```

Look for `profile::freeipa::server::admin_password` and if you see
something like `DEC(13)::PKCS7[g6B6WPXZBMXc]!`, then the username password
for ipa is `admin` / `g6B6WPXZBMXc`.
