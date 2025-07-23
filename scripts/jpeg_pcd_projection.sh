#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

camera_name=$1 
save_path=$HOME/pix/parameter/check
[ ! -d $save_path ] && mkdir -p $save_path

$SCRIPT_DIR/jpeg_pcd_projection.py $camera_name $save_path