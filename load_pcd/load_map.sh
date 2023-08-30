#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch $SCRIPT_DIR/pointcloud_map_loader.launch.xml \
    pointcloud_map_path:=$SCRIPT_DIR/scans_down.pcd \
    pcd_metadata_path:="$SCRIPT_DIR/pcd_metadata_param.yaml"