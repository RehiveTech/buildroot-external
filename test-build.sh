#! /bin/bash

# Usage: ./test-build.sh [tmp-test-dir|--] [targets..]
#
# The tool builds configurations based on the targets lists.
# The targets are derrived from configs/*_defconfig files.
#
# If no tmp-test-dir is specfied then _tmp directory is
# created and used for the testing builds.
#
# It is possible to define path to buildroot environment
# by BUILDROOT environment variable.
#
# Buildroot stores the downloaded archives in a separate
# directory. The script shares this directory located in
# _dl/ among builds. To override, set the environment
# variable DL_DIR.
#
# A separate log file is created for each build.

die()
{
	echo "$@" >&2
	exit 1
}

step()
{
	dir="$1"
	shift
	echo "$@" >> $dir/steps.log
}

tee_log()
{
	dir="$1"
	name="$2"
	tee $3 "$dir/build.${name}.log"
}

list_targets()
{
	dir="$1"
	ls $dir/configs | sed 's/_defconfig$//' | tr '\n' ' '
}

test -z "$BUILDROOT" && BUILDROOT=`pwd`/../buildroot
test -d $BUILDROOT || die "missing buildroot, check variable BUILDROOT ($BUILDROOT)" 

EXTERNAL=`pwd`

TEST_DIR=`pwd`/_tmp
test -z "$1" || test "$1" == "--" || TEST_DIR=`realpath $1`
shift
test -d $TEST_DIR && die "directory '$TEST_DIR' exists, remove it first"
echo TEST_DIR: $TEST_DIR >&2

test -z "$1" && die "no target specified, try: `list_targets "$EXTERNAL"`"

test -z "$DL_DIR" && DL_DIR=`pwd`/_dl

mkdir -p $TEST_DIR
mkdir -p $DL_DIR

pushd $TEST_DIR >/dev/null 2>/dev/null

for target in "$@"; do
	make -C "$BUILDROOT" O="$TEST_DIR/$target" BR2_EXTERNAL="$EXTERNAL" ${target}_defconfig \
		| tee_log "$TEST_DIR" $target
	step "$TEST_DIR" "output for $target generated"

	echo BR2_DL_DIR="$DL_DIR" >> $target/.config
	make -C $target | tee_log "$TEST_DIR" $target -a
	step "$TEST_DIR" "make for $target successful"
done

popd > /dev/null 2>/dev/null
