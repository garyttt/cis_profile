#! /bin/bash
# 
# check_typos_in_data_os_yamls.sh
#
# Note: this script is run as and when needed after typos fix script has been run
#
[ $EUID -ne 0 ] && echo "Not root" && exit 1
SLC_HIERA_DATA_PATH=/etc/puppetlabs/code/environments/production/modules/secure_linux_cis/data
SLC_RULES_PP_PATH=/etc/puppetlabs/code/environments/production/modules/secure_linux_cis/manifests/rules
for FILE in `find $SLC_HIERA_DATA_PATH -name "*.yaml"`
do
  for RULES in `cat $FILE | grep -v "^#" | grep "\- " | cut -d' ' -f2`
  do
    #echo "Checking $RULES in HIERA $FILE ..."
    FOUND=`ls -1d ${SLC_RULES_PP_PATH}/$RULES.pp 2>/dev/null`
    if [ -z "$FOUND" ]; then
      echo "$RULES.pp is not found in rules folder !!!"
      echo "Please check and fix typo errors in data/os/[OSNAME]/version/[MAJOR_RELEASE].yaml ..."
    fi 
  done
done
