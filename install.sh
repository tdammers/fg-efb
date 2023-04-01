#!/bin/bash
AIRCRAFT_DIR="$1"
SRC_DIR="$(dirname "$0")"

if [ "$AIRCRAFT_DIR" == "" ]
then
    echo "Please specify an aircraft directory."
fi

# dependencies
rsync -r "$SRC_DIR/Nasal/html/" "$AIRCRAFT_DIR/Nasal/html/" --exclude ".git"

# core files
rsync -r "$SRC_DIR/Nasal/efb/" "$AIRCRAFT_DIR/Nasal/efb/"
rsync -r "$SRC_DIR/Nasal/efb.nas" "$AIRCRAFT_DIR/Nasal/efb.nas"
rsync -r "$SRC_DIR/Systems/EFB.xml" "$AIRCRAFT_DIR/Systems/EFB.xml"
rsync -r "$SRC_DIR/Models/EFB/" "$AIRCRAFT_DIR/Models/EFB/"
rsync -r "$SRC_DIR/Fonts/SteveHand/" "$AIRCRAFT_DIR/Fonts/SteveHand/"
