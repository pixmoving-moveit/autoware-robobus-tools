#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front/livox/points \
    initial_pose:='[ -6.25645, -0.558192, 0.738937, 0.0, 0.0, 3.14]' \
    leaf_size:=0.6 \
    node_name:='livox_120'
