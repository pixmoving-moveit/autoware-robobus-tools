#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/ancillary/ouster/points \
    initial_pose:='[1.35749, 1.92566, 0.0422595, 0.0862091, -0.00154772, 0.0241381 ]' \
    node_name:='ancillary_node'
