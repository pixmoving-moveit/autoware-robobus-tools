#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_right/ouster/points \
    initial_pose:='[1.29626,   -2.921884, -0.415867,  -3.13429,   -3.0, 1.87643]'\
    node_name:='rs_121'

