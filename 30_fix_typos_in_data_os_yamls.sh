#! /bin/bash
#
# fix_typos_in_data_os_yamls.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
cat <<EOF > /tmp/$$.tmp
ensure_authselect_includes_withfaillock:ensure_authselect_includes_with_faillock
ensure_imap_and_pop3_server_are_not_installed:ensure_imap_and_pop3_server_is_not_installed
ensure_iptables_package_is_installed:ensure_iptables_packages_are_installed
ensure_iptablesservices_package_is_not_installed:ensure_iptables_services_package_is_not_installed
ensure_netsnmp_is_not_installed:ensure_net_snmp_is_not_installed
ensure_nfs_is_not_installed:ensure_nfs_is_not_enabled
ensure_nftables_is_not_enabled:ensure_nftables_is_not_installed
ensure_nodev_option_set_on_run_shm_partition:ensure_nodev_option_set_on_dev_shm_partition
ensure_noexec_option_set_on_run_shm_partition:ensure_noexec_option_set_on_dev_shm_partition
ensure_nosuid_option_set_on_run_shm_partition:ensure_nosuid_option_set_on_dev_shm_partition
ensure_password_hashing_algorithm_is_sha512:ensure_password_hashing_algorithm_is_sha_512
ensure_permissions_on_etc_issuenet_are_configured:ensure_permissions_on_etc_issue_net_are_configured
ensure_rpc_is_not_installed:ensure_rpc_is_not_enabled
ensure_rsync_service_is_not_installed:ensure_rsync_service_is_not_enabled
ensure_snmp_server_is_not_installed:ensure_snmp_server_is_not_enabled
ensure_sticky_bit_is_set_on_all_world_dashwritable_directories:ensure_sticky_bit_is_set_on_all_world_writable_directories
ensure_sticky_bit_is_set_on_all_worldwritable_directories:ensure_sticky_bit_is_set_on_all_world_writable_directories
ensure_systemwide_crypto_policy_is_future_or_fips:ensure_system_wide_crypto_policy_is_future_or_fips
ensure_systemwide_crypto_policy_is_not_legacy:ensure_system_wide_crypto_policy_is_not_legacy
ensure_systemwide_crypto_policy_is_not_overridden:ensure_system_wide_crypto_policy_is_not_over_ridden
ensure_telnetserver_is_not_installed:ensure_telnet_server_is_not_installed
ensure_that_strong_key_exchange_algorithms_are_used:ensure_only_strong_key_exchange_algorithms_are_used
EOF
for LINE in `cat /tmp/$$.tmp`
do
  TYPO=`echo $LINE | cut -d':' -f1`  
  CORRECTION=`echo $LINE | cut -d':' -f2`  
  cd /etc/puppetlabs/code/environments/production/modules/secure_linux_cis/data/os
  for YAML in `find . -name "*.yaml"`
  do
    echo "Fixing $TYPO: replace it with $CORRECTION in $YAML"
    sed -i "s/$TYPO/$CORRECTION/g" $YAML
  done
done
rm -f /tmp/$$.tmp