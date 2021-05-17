#! /bin/bash
#
# re-enable_disabled_classes
#
# Note: this script is run as and when needed to re-enable disabled class(es)
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
cat <<EOF > /tmp/$$.tmp
ensure_access_to_the_su_command_is_restricted
ensure_rsync_service_is_not_enabled
ensure_rsync_service_is_not_installed
EOF
for CLASS in `cat /tmp/$$.tmp`
do
  cd /etc/puppetlabs/code/environments/production/modules/secure_linux_cis/data/os
  for YAML in `find . -name "*.yaml"`
  do
    echo "Disabling $CLASS in $YAML"
    sed -i "s/^#.*- $CLASS/- $CLASS/g" $YAML
  done
done
rm -f /tmp/$$.tmp
