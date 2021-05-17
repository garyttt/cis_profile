## cis_profile

# References:
. https://puppet.com/docs/pe/2021.1/pe_user_guide.html
. https://puppet.com/try-puppet/puppet-enterprise/download/
. https://forge.puppet.com/modules/fervid/secure_linux_cis
. https://github.com/fervidus/secure_linux_cis

# Pre-requisites
. One Puppet Enterprise 2021.1 (based on Puppet 7) Primary Master has been setup (OS:  CentOS 8)
. Two Puppet Enterise 2021.1 Agents have been setup (OS: CentOS8 or Ubuntu 20.04)

# How to install

Login to Puppet Enterprise Master
$ git clone git@github.com:garyttt/cis_profile.git
$ cd cis_profile
$ sudo ./install.sh
After a few minutes, it is done.

# How to setup the configuration in PE Console to perform Cyber-Hygiene of two nodes
Refer to the doc:
(To be posted)
