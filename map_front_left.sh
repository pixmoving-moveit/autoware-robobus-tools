#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_left/ouster/points \
    initial_pose:='[ -6.25645, -0.558192, 0.738937, 0.3, -0.1,1.08487 ]' \
    node_name:='rs_120'
