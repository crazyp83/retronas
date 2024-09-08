#!/bin/bash

_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh

cd $ANDIR
ROLESPATH=$(awk '/roles_path/{print $3}' ansible.cfg)
ROLES=$(awk '/-/{print $3}' requirements.yml)

for ROLE in ${ROLES[@]}
do
  if [ ! -d ${ROLESPATH}/${ROLE} ]
  then
    ansible-galaxy install -r requirements.yml
    break
  fi
done