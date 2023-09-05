#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/concatenated/pointcloud_unfilter \
    initial_pose:='[-5.23789, 0.523736, 0.997722, 0.0, 0.0, 3.3]' \
    node_name:='ubfilter_node'
