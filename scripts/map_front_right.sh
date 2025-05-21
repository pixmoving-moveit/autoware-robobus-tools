#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_right/points \
    initial_pose:='[-70.0, -30.0, 0.735304,  0.1, -3.14, 2.8]'\
    leaf_size:=0.3 \
    node_name:='Airy_123'

