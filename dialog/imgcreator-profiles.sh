#!/bin/bash

#set -x

clear
_CONFIG=/opt/retronas/config/retronas.cfg
source $_CONFIG
source ${LIBDIR}/common.sh
PROFILED="${OLDRNPATH}/config/formats"

cd ${DIDIR}

DROP_ROOT
CLEAR

if [ ! -d "${PROFILED}" ]
then
    echo "${PROFILED} not found, exiting"
    PAUSE
    exit 1
fi

[ -f ${TDIR}/rn_imgcreator-profile ] && rm ${TDIR}/rn_imgcreator-profile

rn_profile_chooser() {
  local MENU_NAME=profiles
  READ_MENU_JSON "${MENU_NAME}"
  READ_MENU_TDESC "${MENU_NAME}"

  MENU_ARRAY=()
  MENU_ARRAY2+=("$PROFILED"/*.fmt )

  if [ "${#MENU_ARRAY2[@]}" -le 0 ] || [ $(echo ${MENU_ARRAY2[@]} | grep "*" ) ]
  then
    echo "No profiles found"
    PAUSE
    exit 1
  fi

  IFS=";"
  for ITEM in "${MENU_ARRAY2[@]}"
  do
    ITEM2=${ITEM##*/}
    ININAME="${ITEM2%%.*}"
    MENU_ARRAY+="$ININAME; ;";
  done

  dialog \
    --backtitle "${MENU_NAME}" \
    --title "${MENU_NAME}" \
    --clear \
    --menu "${MENU_BLURB}" ${MW} ${MH} 10 \
    ${MENU_ARRAY[@]} \
    2> ${TDIR}/rn_imgcreator-profile

    CLEAR

    PROFILE="$(cat ${TDIR}/rn_imgcreator-profile)"
    if [ ! -z "$PROFILE" ]
    then
      bash imgcreator-details.sh $PROFILE
      bash imgcreator-profiles.sh
    else
      exit 1
    fi
}

rn_profile_chooser
