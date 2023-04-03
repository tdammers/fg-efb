#!/bin/bash
AIRCRAFT_DIR="$1"
SRC_DIR="$(dirname "$0")"

if [ "$AIRCRAFT_DIR" == "" ]
then
    echo "Please specify an aircraft directory."
fi

# core files
rsync -r "$AIRCRAFT_DIR/Nasal/efb/" "$SRC_DIR/Nasal/efb/"
rsync -r "$AIRCRAFT_DIR/Nasal/efb.nas" "$SRC_DIR/Nasal/efb.nas"
rsync -r "$AIRCRAFT_DIR/Systems/EFB.xml" "$SRC_DIR/Systems/EFB.xml"
rsync -r "$AIRCRAFT_DIR/Models/EFB/" "$SRC_DIR/Models/EFB/"
rsync -r "$AIRCRAFT_DIR/Fonts/SteveHand/" "$SRC_DIR/Fonts/SteveHand/"
