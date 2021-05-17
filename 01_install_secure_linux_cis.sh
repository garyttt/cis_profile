#! /bin/bash
#
# install_secure_linux_cis.sh
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
yum install -y jq || apt-get install -y jq || true
export PATH=/opt/puppetlabs/puppet/bin:$PATH
cd /etc/puppetlabs/code/environments/production/modules
echo "Installing supporting puppet modules."
puppet module install puppetlabs-stdlib
puppet module install puppetlabs-concat
puppet module install puppetlabs-translate
puppet module install camptocamp-systemd
puppet module install fervid-secure_linux_cis --version 3.0.0 --force
# next few lines fixes missing dependency nftables
sed -i 's:puppetlabs/nftables:puppet/nftables:' secure_linux_cis/metadata.json
N=`grep -n 'nftables' secure_linux_cis/metadata.json | cut -d':' -f1`
let N=N+1
sed -i "$N s/1.0.2/2.0.0/" secure_linux_cis/metadata.json
while IFS= read -r LINE
do
  MOD=`echo $LINE | cut -d' ' -f1 | tr '/' '-'`
  VER=`echo $LINE | cut -d' ' -f2-`
  puppet module install $MOD --version "$VER" --force
  [ $? -eq 0 ] && echo "$MOD has been successfully installed."
  [ $? -ne 0 ] && echo "$MOD has not been installed !!!"
  MODNAME=`echo $MOD | cut -d'-' -f2`
  if [ $MODNAME != 'stdlib' ]; then
    # next few lines fixes invalid stdlib version
    N=`grep -n 'stdlib' $MODNAME/metadata.json | cut -d':' -f1`
    let N=N+1
    sed -i "$N s/7.0.0/8.0.0/" $MODNAME/metadata.json
  fi
done <<< $(jq -r '.dependencies[] | [.name, .version_requirement] | @tsv' secure_linux_cis/metadata.json)
# next few lines fixes invalid concat version
N=`grep -n 'concat' nftables/metadata.json | cut -d':' -f1`
let N=N+1
sed -i "$N s/7.0.0/8.0.0/" nftables/metadata.json
# next few lines fixes invalid systemd version
N=`grep -n 'systemd' nftables/metadata.json | cut -d':' -f1`
let N=N+1
sed -i "$N s/3.0.0/4.0.0/" nftables/metadata.json
echo "Verifying puppet module list..."
puppet module list
