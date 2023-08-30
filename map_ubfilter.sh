#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/concatenated/pointcloud_unfilter \
    initial_pose:='[3.90265, 3.68133, 1.08971, 0.141197, 3.13604, 3.12115 ]' \
    node_name:='ubfilter_node'
