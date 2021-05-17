#! /bin/bash
#
# disable_excluded_classes.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
cat <<EOF > /tmp/$$.tmp
ensure_access_to_the_su_command_is_restricted
ensure_a_firewall_package_is_installed
ensure_aide_is_installed
ensure_all_apparmor_profiles_are_enforcing
ensure_all_apparmor_profiles_are_in_enforce_or_complain_mode
ensure_apparmor_is_installed
ensure_apparmor_is_not_disabled_in_bootloader_configuration
ensure_bootloader_password_is_set
ensure_default_deny_firewall_policy
ensure_firewalld_service_is_enabled_and_running
ensure_firewall_rules_exist_for_all_open_ports
ensure_http_server_is_not_enabled
ensure_http_server_is_not_installed
ensure_iptables_are_flushed
ensure_iptables_is_enabled_and_running
ensure_iptables_is_installed
ensure_iptables_packages_are_installed
ensure_iptables_rules_are_saved
ensure_ipv4_default_deny_firewall_policy
ensure_ipv4_loopback_traffic_is_configured
ensure_ipv6_default_deny_firewall_policy
ensure_ipv6_firewall_rules_exist_for_all_open_ports
ensure_ipv6_loopback_traffic_is_configured
ensure_journald_is_configured_to_send_logs_to_rsyslog
ensure_ldap_client_is_not_installed
ensure_ldap_server_is_not_installed
ensure_loopback_traffic_is_configured
ensure_net_snmp_is_not_installed
ensure_nfs_and_rpc_are_not_enabled
ensure_nfs_is_not_enabled
ensure_nfs_is_not_installed
ensure_nfs_utils_is_not_installled_or_the_nfs_server_service_is_masked
ensure_nftables_is_installed
ensure_nftables_rules_are_permanent
ensure_nftables_service_is_enabled
ensure_nis_client_is_not_installed
ensure_nis_server_is_not_enabled
ensure_ntp_is_configured
ensure_remote_rsyslog_messages_are_only_accepted_on_designated_log_hosts
ensure_remote_syslog_ng_messages_are_only_accepted_on_designated_log_hosts
ensure_rpc_is_not_installed
ensure_rsync_service_is_not_enabled
ensure_rsync_service_is_not_installed
ensure_rsyslog_default_file_permissions_configured
ensure_rsyslog_is_configured_to_send_logs_to_a_remote_log_host
ensure_rsyslog_is_installed
ensure_rsyslog_or_syslog_ng_is_installed
ensure_rsyslog_service_is_enabled
ensure_rsyslog_service_is_enabled_and_running
ensure_selinux_is_enabled_in_the_bootloader_configuration
ensure_selinux_is_installed
ensure_selinux_is_not_disabled_in_bootloader_configuration
ensure_selinux_or_apparmor_are_installed
ensure_selinux_policy_is_configured
ensure_snmp_server_is_not_installed
ensure_ssh_access_is_limited
ensure_syslog_ng_default_file_permissions_configured
ensure_syslog_ng_is_configured_to_send_logs_to_a_remote_log_host
ensure_syslog_ng_service_is_enabled
ensure_the_selinux_mode_is_enforcing
ensure_the_selinux_mode_is_enforcing_or_permissive
ensure_the_selinux_state_is_enforcing
ensure_ufw_service_is_enabled
ensure_x11_server_components_are_not_installed
ensure_x_window_system_is_not_installed
EOF
COMMON=/etc/puppetlabs/code/environments/production/modules/cis_profile/data/common.yaml
cp -p $COMMON.orig $COMMON
echo "" >> $COMMON
echo "# Example of exclude_rules in sorted order" >> $COMMON
echo "cis_profile::exclude_rules:" >> $COMMON
for CLASS in `cat /tmp/$$.tmp`
do
  echo "- secure_linux_cis::rules::$CLASS" >> $COMMON
  cd /etc/puppetlabs/code/environments/production/modules/secure_linux_cis/data/os
  for YAML in `find . -name "*.yaml"`
  do
    echo "Disabling $CLASS in $YAML"
    sed -i "s/^- $CLASS/# - $CLASS/g" $YAML
  done
done
rm -f /tmp/$$.tmp
