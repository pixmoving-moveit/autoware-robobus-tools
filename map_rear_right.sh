#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/rear_right/ouster/points \
    initial_pose:='[3.10474,   -1.966971, -0.452921,  3.14137,   3.08721, 1.24932]'\
    node_name:='rear_right'

