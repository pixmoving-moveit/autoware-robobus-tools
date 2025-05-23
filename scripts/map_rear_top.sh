#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/rear_top/points \
    initial_pose:='[-69.0, -30.0,  1.73441,  0.2, 0.0, -1.5]'\
    leaf_size:=0.5 \
    node_name:='M1P_121'
