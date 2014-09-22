#! /bin/sh

mkimage=$HOST_DIR/usr/bin/mkimage
$mkimage -A arm -T script -d $2/board/altera_sockit/u-boot.txt $BINARIES_DIR/u-boot.scr
