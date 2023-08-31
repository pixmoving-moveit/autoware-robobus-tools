#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/rslidar_sdk/rs/points \
    initial_pose:='[-4.93371, 0.327382,  1.11241, 3.13236, 3.13892, 0.113313]' \
    node_name:='rs_top'