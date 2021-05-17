#! /bin/bash
# 
# fix_data_os_ubuntu_20_04_yaml.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
U2004=/etc/puppetlabs/code/environments/production/modules/secure_linux_cis/data/os/Ubuntu/version/20.04.yaml
EXCLUDES="ensure_iptables_persistent_is_not_installed|ensure_uncomplicated_firewall_is_installed"
FOUND=`cat $U2004 | grep -v "^#" | egrep "$EXLCUDES"`
if [ -n "$FOUND" ]; then
  sed -i 's/- ensure_iptables_persistent_is_not_installed/# - ensure_iptables_persistent_is_not_installed/g' $U2004
  sed -i 's/- ensure_uncomplicated_firewall_is_installed/# - ensure_uncomplicated_firewall_is_installed/g' $U2004
fi
