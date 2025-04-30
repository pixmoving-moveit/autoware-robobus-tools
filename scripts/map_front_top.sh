#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_top/points\
    initial_pose:='[ 1.0, -0.558192, 1.138937, 0.0, 0.0, 3.2]' \
    leaf_size:=0.2 \
    node_name:='M1P_120'
