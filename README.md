## cis_profile

# References:
* https://puppet.com/blog/enforcing-cis-benchmarks-on-linux-using-puppet/
* https://forge.puppet.com/modules/fervid/secure_linux_cis
* https://github.com/fervidus/secure_linux_cis
* https://puppet.com/docs/pe/2021.1/pe_user_guide.html
* https://puppet.com/try-puppet/puppet-enterprise/download/
* https://puppet.com/docs/pe/2019.8/osp/the_roles_and_profiles_method.html

# Pre-requisites
* One Puppet Enterprise 2021.1 (based on Puppet 7) Primary Master has been setup (OS: CentOS 8)
* Two Puppet Enterise 2021.1 Agents have been setup (OS: CentOS 8 or Ubuntu 20.04)

# How to install
Login to Puppet Enterprise Master
```bash
$ git clone git@github.com:garyttt/cis_profile.git
$ cd cis_profile
$ sudo ./install.sh
```
After a few minutes, it is done.

# How to perform Cyber-Hygiene of two nodes
Refer to the doc:
* https://github.com/garyttt/cis_profile/blob/main/How%20to%20perform%20Cyber-Hygiene%20using%20Puppet%20Enterprise%202021_1.docx
