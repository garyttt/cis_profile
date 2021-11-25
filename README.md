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
$ git clone https://github.com/garyttt/cis_profile.git
$ cd cis_profile
$ sudo ./install.sh
```
After a few minutes, it is done.

* Check 'puppet module list' for warnings or errors
* If for some reason camptocamp-systemd was not installed to latest 3.0.0 level, login as root and perform the following clean-up and re-install fix:
```bash
# puppet module list
# cd /etc/puppetlabs/code/environments/production/modules
# rm -rf systemd
# puppet module install camptocamp-systemd
# puppet module list
```
Outputs:
```
[root@puppet ~]# puppet module list
/etc/puppetlabs/code/environments/production/modules
├── aboe-chrony (v0.3.2)
├── camptocamp-augeas (v1.9.0)
├── camptocamp-kmod (v2.5.0)
├── camptocamp-postfix (v1.12.0)
├── camptocamp-systemd (v3.0.0)
├── fervid-secure_linux_cis (v3.0.0)
├── gtay-cis_profile (v0.1.0)
├── herculesteam-augeasproviders_core (v2.7.0)
├── herculesteam-augeasproviders_grub (v3.2.0)
├── herculesteam-augeasproviders_pam (v2.3.0)
├── herculesteam-augeasproviders_shellvar (v4.1.0)
├── herculesteam-augeasproviders_sysctl (v2.6.2)
├── kemra102-auditd (v2.2.0)
├── puppet-alternatives (v3.0.0)
├── puppet-cron (v2.0.0)
├── puppet-firewalld (v4.4.0)
├── puppet-logrotate (v5.0.0)
├── puppet-nftables (v1.3.0)
├── puppetlabs-augeas_core (v1.2.0)
├── puppetlabs-concat (v7.1.1)
├── puppetlabs-firewall (v2.8.1)
├── puppetlabs-inifile (v5.2.0)
├── puppetlabs-mailalias_core (v1.1.0)
├── puppetlabs-mount_core (v1.1.0)
├── puppetlabs-ntp (v8.5.0)
├── puppetlabs-reboot (v2.4.0)
├── puppetlabs-stdlib (v7.0.0)
└── puppetlabs-translate (v2.2.0)
/etc/puppetlabs/code/modules (no modules installed)
/opt/puppetlabs/puppet/modules
├── puppetlabs-cd4pe_jobs (v1.5.0)
├── puppetlabs-enterprise_tasks (v0.1.0)
├── puppetlabs-facter_task (v1.1.0)
├── puppetlabs-facts (v1.4.0)
├── puppetlabs-package (v2.1.0)
├── puppetlabs-pe_bootstrap (v0.3.0)
├── puppetlabs-pe_concat (v1.1.1)
├── puppetlabs-pe_databases (v2.2.0)
├── puppetlabs-pe_hocon (v2019.0.0)
├── puppetlabs-pe_infrastructure (v2018.1.0)
├── puppetlabs-pe_inifile (v1.1.3)
├── puppetlabs-pe_install (v2018.1.0)
├── puppetlabs-pe_nginx (v2017.1.0)
├── puppetlabs-pe_patch (v0.13.0)
├── puppetlabs-pe_postgresql (v2016.5.0)
├── puppetlabs-pe_puppet_authorization (v2016.2.0)
├── puppetlabs-pe_r10k (v2016.2.0)
├── puppetlabs-pe_repo (v2018.1.0)
├── puppetlabs-pe_staging (v0.3.3)
├── puppetlabs-pe_support_script (v3.0.0)
├── puppetlabs-puppet_conf (v1.2.0)
├── puppetlabs-puppet_enterprise (v2018.1.0)
├── puppetlabs-puppet_metrics_collector (v7.0.5)
├── puppetlabs-python_task_helper (v0.5.0)
├── puppetlabs-reboot (v4.1.0)
├── puppetlabs-ruby_task_helper (v0.6.0)
└── puppetlabs-service (v2.1.0)
[root@puppet ~]#
```

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
