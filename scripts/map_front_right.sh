#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_right/points \
    initial_pose:='[0.5, -1.5, 0.0, 0.0, 3.14, -2.05]'\
    leaf_size:=0.1 \
    node_name:='Airy_123'

