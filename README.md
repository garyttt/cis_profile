## cis_profile

# References:
* https://puppet.com/blog/enforcing-cis-benchmarks-on-linux-using-puppet/
* https://forge.puppet.com/modules/fervid/secure_linux_cis
* https://github.com/fervidus/secure_linux_cis
* https://puppet.com/docs/pe/2021.1/pe_user_guide.html
* https://puppet.com/try-puppet/puppet-enterprise/download/
* https://puppet.com/docs/puppet/7.6/hiera_intro.html
* https://puppet.com/docs/pe/2021.1/osp/the_roles_and_profiles_method.html
* https://www.cisecurity.org/cis-benchmarks/

# Pre-requisites
* One Puppet Enterprise 2021.1 (based on Puppet 7) Primary Master has been setup (OS: CentOS 8)
* Two Puppet Enterprise 2021.1 Agents have been setup (OS: CentOS 8 or Ubuntu 20.04)

# How to install
Login to Puppet Enterprise Master
```bash
$ git clone git@github.com:garyttt/cis_profile.git
$ cd cis_profile
$ sudo ./install.sh
```
After a few minutes, it is done.

# Summary of what these scripts do

* 01_install_secure_linux_cis.sh and 02_install_cis_profile.sh scripts install the CIS Benchmarked security_linux_cis COMPONENT module, and cis_profile PROFILE module, it is good design principle to have three levels of Puppet Modules:
* ```Component modules``` — Normal modules that manage one particular technology, for example puppetlabs/apache.
* ```Profiles — Wrapper``` classes that use multiple component modules to configure a layered technology stack.
* ```Roles``` — Wrapper classes that use multiple profiles to build a complete system configuration.

* 10_disable_exclude_classes.sh
* Many OS hardening Puppet Forge modules would contain rules to harden Firewall (host based likes iptables and nftables) and SSH related system settings (host based likes AllowUsers and AllowGroups in SSH Server Configs), these settings could cause server crashes and user login issues, and therefore it is better to exclude these in the HIERA data/os hierachies of OSNAME based Major_Release yaml files.

* 20_fix_ensure_sudo_is_installed.sh
* Instead of including an non-existing sudo class, we declare its packaging.

* 30_fix_typos_data_os_yamls.sh
* Fixes typo errors in the HIERA data/os hierachies of OSNAME based Major_Release yaml files.

* 40_fix_data_os_ubuntu_20_04.sh
* Fixes non-existing rules in this yaml file.

* 99_check_typo_in_data_os_yaml_files.sh
* Assuming naming of rules are correct in rules folder, check for incorrect references in data/os yaml files. This is run as and when needed.

* 99_re-enable_disabled_classes.sh
* If the security team has decided to implement host based firewall or SSH Server users or groups based access control, they can feel free to re-enable these risky rules by un-commenting them in data/os yaml files, these form the base_rules, and the resultant enforced_rules is usually:

# enforced_rules = base_rules + include_rules - exclude_rules

# How to perform Cyber-Hygiene of two nodes

Login to Puppet Enterprise 2021.1 Console and refer to the doc:
* https://github.com/garyttt/cis_profile/blob/main/How%20to%20perform%20Cyber-Hygiene%20using%20Puppet%20Enterprise%202021_1.docx

The doc describes the steps to define ```Nodes_Group``` (which was called ```Classifications``` in older version of Puppet Enterprise) which is the instance of ```class```, followed by typicall parameters to get the ```cis_profile``` initiated, after which ```'Pin node'``` will add the Nodes into Nodes_Group, any puppet agent run will ensure the Desired States get enforced (other nice calling it would be ```Auto-Healing``` or ```Auto-Cyber-Hygiened```).
