#!/bin/sh
if [ "$1" ]
then
    FILE=$1
    NAME=$(basename $FILE)
    SIZE=$(du -b $FILE | awk '{print $1}')
    SHA1=$(sha1sum $FILE | awk '{print $1}')
    MD5=$(md5sum $FILE | awk '{print $1}')
    OUT=${FILE%/*}
    DEVICE=${OUT##*/}

    DATE=$(grep ro\.neoteric\.date\.utc ./out/target/product/$DEVICE/system/build.prop | cut -d= -f2);
    DATE_S=`date -u "+%Y_%m_%d" -d @$DATE`

    JSON_DEVICE_DIR=ota/$DEVICE
    JSON=$JSON_DEVICE_DIR/ota.json

    CHANGELOG_FILE=$JSON_DEVICE_DIR"/changelog_"$DATE_S".txt"

    if [ ! -d $JSON_DEVICE_DIR ]; then
        mkdir -p $JSON_DEVICE_DIR
    fi

    VERSION=`grep ro.neoteric.version $OUT/system/build.prop | sed "s/ro.neoteric.version=//"`

    # Generate ota json
    :> $JSON
    echo "{" >> $JSON
    echo "    \"version\": \""$VERSION"\"," >> $JSON
    echo "    \"date\": \""$DATE"\"," >> $JSON
    echo "    \"url\": \"https://sourceforge.net/projects/marble-files/files/Neoteric-OS/Android-16/"$DEVICE"/"$NAME"/download\"," >> $JSON
    echo "    \"id\": \""$SHA1"\"," >> $JSON
    echo "    \"filename\": \""$NAME"\"," >> $JSON
    echo "    \"filesize\": \""$SIZE"\"," >> $JSON
    echo "    \"md5\": \""$MD5"\"" >> $JSON
    echo "}" >> $JSON

    touch $CHANGELOG_FILE

    echo "Succesfully generated json: "$JSON
    echo "Please fill in changelog to "$CHANGELOG_FILE
fi
