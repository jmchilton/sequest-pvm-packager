#!/bin/bash

SEQUEST_PACKAGE_NAME=${SEQUEST_PACKAGE_NAME:-sequest}
SEQUEST_VERSION=${SEQUEST_VERSION:-"27"}
# Binaries directory should contain master and slave PVM procs
SEQUEST_BINARIES_LOCATION="../sequest_binaries"

echo "Checking for fpm..."
type fpm 
if [ "$?" != "0" ];
then 
    echo "fpm is required. Please install ruby and then fpm via `gem install fpm`"
    exit 1
fi

SCRIPT_DIR=$(readlink -f `dirname $0`)
SEQUEST_PACKAGE_TYPE=${SEQUEST_PACKAGE_TYPE:-deb}  # Consult fpm documentation for other options
CONTENTS_DIR=$SCRIPT_DIR/contents
echo "Installing sequest locally to $CONTENTS_DIR"
SEQUEST_SHARE=$CONTENTS_DIR/usr/share/sequest
mkdir -p $SEQUEST_SHARE
echo "Copying sequest binaries into share directory"
cp $SEQUEST_BINARIES_LOCATION/* $SEQUEST_SHARE/
chmod a+rx $SEQUEST_SHARE/*
echo "Copying wrapper into bin directory"
mkdir -p $CONTENTS_DIR/usr/bin
cp $SCRIPT_DIR/run_sequest $CONTENTS_DIR/usr/bin/
chmod a+rx $CONTENTS_DIR/usr/bin/*

# -a all
echo "Packaging sequest"
fpm -s dir -t $SEQUEST_PACKAGE_TYPE -n "${SEQUEST_PACKAGE_NAME}" -v $SEQUEST_VERSION -C $CONTENTS_DIR --depends pvm 