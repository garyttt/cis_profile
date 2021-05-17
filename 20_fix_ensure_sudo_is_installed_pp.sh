#! /bin/bash
# 
# fix_ensure_sudo_is_installed_pp.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
cd /etc/puppetlabs/code/environments/production/modules/secure_linux_cis/manifests/rules
SUDOPP=ensure_sudo_is_installed.pp
FOUND=`cat $SUDOPP | grep -v "#" | grep "include sudo" `
if [ -n "$FOUND" ]; then
  sed -i 's/include sudo/# include sudo/' $SUDOPP
  FOUND2=`grep -n "package.*sudo.*" $SUDOPP 2>/dev/null`
  if [ -n "$FOUND2" ]; then
    S=`echo $FOUND2 | cut -d':' -f1`
    let E=S+2
    sed -i "$S,$E s/# //g" $SUDOPP
  fi
fi
