#!/bin/bash
PROJECT_DIR="$(dirname "$0")"
cd "$PROJECT_DIR"
rsync -rv submodules/fg-canvas-html/Nasal/ ./Nasal/
