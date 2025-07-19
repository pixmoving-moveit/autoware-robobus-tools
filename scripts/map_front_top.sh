#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_top/points\
    initial_pose:='[2.0, -1.0, 2.0, 0.0, 0.05, 0.03]' \
    output/cropped_target_pointcloud:=/sensing/lidar/front_top/cropped_points \
    crop_box_min_x:='5.0' \
    crop_box_min_y:='5.0' \
    crop_box_min_z:='-4.0' \
    crop_box_max_x:='13.0' \
    crop_box_max_y:='20.0' \
    crop_box_max_z:='2.0' \
    leaf_size:=0.5 \
    node_name:='M1P_120'
