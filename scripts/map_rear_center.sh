#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/rear/center/points \
    initial_pose:='[4.1983,  1.3575, 0.73441,  0.0, 0.0, 0.0]'\
    leaf_size:=0.3 \
    node_name:='E1R_124'
