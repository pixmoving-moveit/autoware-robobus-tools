#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch $SCRIPT_DIR/load_pcd/pointcloud_map_loader.launch.xml \
    pointcloud_map_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    pcd_metadata_path:="$SCRIPT_DIR/load_pcd/pcd_metadata_param.yaml"