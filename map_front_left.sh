#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_left/ouster/points \
    initial_pose:='[1.81792, -4.00162,  0.65118,  0.0336716, -0.305245, 1.2935]' \
    node_name:='rs_120'
