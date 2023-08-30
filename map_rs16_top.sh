#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/rslidar_sdk/rs/points \
    initial_pose:='[2.5, -4.0,  1.5,  0.0, 0.0, 3.20]' \
    node_name:='rs_top'
