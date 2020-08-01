#!/bin/bash


BASE_IMAGE_PATH=${PWD}'/images/'
TMP_BUILD_PATH=${PWD}'/tmp/'

if [ $# -ne 1 ]
then
  echo -e "please provide version to deploy..\n$0 [9.6|9.7]"
  exit
fi

VER=$@
echo $VER
if [ $VER == '9.7' ]
then
  VERSION='vsim-netapp-DOT9.7-cm_nodar'
  BASE_IMAGE=${VERSION}'.ova'
elif [ $VER == '9.6' ]
then
  VERSION='vsim-netapp-DOT9.6-cm_nodar'
  BASE_IMAGE=${VERSION}'.ova'
else
  echo "version not supported"
fi

echo $BASE_IMAGE

[ ! -d $TMP_BUILD_PATH ] && mkdir -p $TMP_BUILD_PATH
ls -ld $TMP_BUILD_PATH

if [ ! -f ${TMP_BUILD_PATH}${BASE_IMAGE} ]
then
  ln -s ${BASE_IMAGE_PATH}${BASE_IMAGE} ${TMP_BUILD_PATH}${BASE_IMAGE}
fi 

ln -s ${PWD}/${VERSION}'.sh' ${TMP_BUILD_PATH}${VERSION}'.sh' 

# run the converter script
cd ${TMP_BUILD_PATH}
${TMP_BUILD_PATH}${VERSION}'.sh' 


# import the vbox compatible new ova file to create a new virtual machine
vboxmanage import ${TMP_BUILD_PATH}${VERSION}'-vbox.ova' 

rm -rf ${TMP_BUILD_PATH}

