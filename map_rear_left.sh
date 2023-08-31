#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/rear_left/ouster/points \
    initial_pose:='[-3.88867, -0.623572,  0.735304,  0.26878,   0.1, 2.00253]'\
    node_name:='rs_122'
