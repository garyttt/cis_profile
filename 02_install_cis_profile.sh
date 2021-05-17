#! /bin/bash
#
# install_cis_profile.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
export PATH=/opt/puppetlabs/puppet/bin:$PATH
CWD=`pwd`
cd /etc/puppetlabs/code/environments/production/modules
echo "Installing cis_profile puppet module."
tar xvf $CWD/cis_profile.tar
puppet module list
