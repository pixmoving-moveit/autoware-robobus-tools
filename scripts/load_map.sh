#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $SCRIPT_DIR/../../autoware-robobus/install/setup.bash

autoware_robobus_calibration_path=$SCRIPT_DIR/..

ros2 launch $SCRIPT_DIR/load_pcd/pointcloud_map_loader.launch.xml \
    pointcloud_map_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    pcd_metadata_path:="$SCRIPT_DIR/load_pcd/pcd_metadata_param.yaml" \
    autoware_robobus_calibration_path:=$autoware_robobus_calibration_path
    
