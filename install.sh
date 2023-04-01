#!/bin/bash
AIRCRAFT_DIR="$1"
SRC_DIR="$(dirname "$0")"

if [ "$AIRCRAFT_DIR" == "" ]
then
    echo "Please specify an aircraft directory."
fi

# dependencies
rsync -r "$SRC/Nasal/html/" "$AIRCRAFT_DIR/Nasal/html/" --exclude ".git"

# core files
rsync -r "$SRC/Nasal/efb/" "$AIRCRAFT_DIR/Nasal/efb/"
rsync -r "$SRC/Nasal/efb.nas" "$AIRCRAFT_DIR/Nasal/efb.nas"
rsync -r "$SRC/Models/EFB/" "$AIRCRAFT_DIR/Models/EFB/"
