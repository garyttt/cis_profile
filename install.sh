#! /bin/bash
[ $EUID -ne 0 ] && echo "Not root" && exit 1
OPTIONS=""
#OPTIONS="-vx"
systemctl stop puppet
bash $OPTIONS 01_install_secure_linux_cis.sh
bash $OPTIONS 02_install_cis_profile.sh
bash $OPTIONS 10_disable_excluded_classes.sh
bash $OPTIONS 20_fix_ensure_sudo_is_installed_pp.sh
bash $OPTIONS 30_fix_typos_in_data_os_yamls.sh
bash $OPTIONS 40_fix_data_os_ubuntu_20_04_yaml.sh
/opt/puppetlabs/puppet/bin/puppet module list
systemctl start puppet
