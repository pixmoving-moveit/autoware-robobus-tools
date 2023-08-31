#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_right/ouster/points \
    initial_pose:='[-6.1983,  1.3575, 0.73441,   -3.4, -3.13438,  2.00635]'\
    node_name:='rs_121'
