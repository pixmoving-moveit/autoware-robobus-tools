#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_left/livox/points \
    initial_pose:='[-4.88867, -0.623572,  0.735304,  0.0,   3.14, -1.2]'\
    leaf_size:=0.2 \
    node_name:='livox_fl_122'
