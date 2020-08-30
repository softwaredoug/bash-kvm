#!/bin/bash
#
# Looks for given USB device
# if connected, you must be docked! connect bluetooth devices
# If not connected, disconnect bluetooth devices
# 
# Depends on "blueutil" install with `brew install blueutil`

# TODO: Change to your USB device name
USB_DEVICE_NAME="HD Pro Webcam"

# TODO: Place list of connect/disconnect device id, newline delimited in devices.txt
# Example file:
# 12-34-56-78-9a-bc
# de-f1-23-45-67-89
IFS=$'\r\n' GLOBIGNORE='*' command eval  'BT_DEVICES=($(cat devices.txt))'

# Where can ioreg and blueutil be found?
export PATH="/usr/local/bin/:/usr/sbin/:$PATH"

if [[ $(ioreg -p IOUSB) =~ "$USB_DEVICE_NAME" ]]; then
    echo "Docked!"
    for i in ${BT_DEVICES[@]}; do
        CONN="$(blueutil --is-connected $i)"
        echo "CONN? $CONN"
        if [ $CONN == "0" ]; then
            echo "Connecting $i"
            blueutil --connect "$i"
        else
            echo "Already Connected $i, doing nothing..."
        fi
    done
else
    echo "Webcam Not Plugged In"
    for i in ${BT_DEVICES[@]}; do
        echo "Disconnecting $i"
        blueutil --disconnect "$i"
    done
fi
