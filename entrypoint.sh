#!/bin/sh

ROOM="${1:-my_office}"
DEVICE=$2 # The serial port/address to use, for example: /dev/ttyUSB0 or 192.168.1.2
ESPHOME_COMMAND="${3:-logs}"

UPLOAD_FILE="" # Optional file path to binary (firmware) which will be uploaded to the MCU

SUBSTITUTIONS="-s name ${ROOM}_ac"

case $ESPHOME_COMMAND in
    logs)
        ;;
    run)
        ;;
    upload)
        UPLOAD_FILE="--file $4"
        ;;
    *)
        echo "Command: '$ESPHOME_COMMAND' not supported"
        exit 1
        ;;
esac

cd /config
git config --global --add safe.directory '*'
esphome config esphome_config.yaml -s name "${ROOM}_ac" # Validate config
esphome $SUBSTITUTIONS $ESPHOME_COMMAND $UPLOAD_FILE --device $DEVICE esphome_config.yaml
