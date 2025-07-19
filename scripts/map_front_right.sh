#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_right/points \
    initial_pose:='[2.0, -2.0, 1.7, 0.1, 3.14, -2.05]'\
    output/cropped_target_pointcloud:=/sensing/lidar/front_right/cropped_points \
    crop_box_min_x:='-2.0' \
    crop_box_min_y:='1.0' \
    crop_box_min_z:='-4.0' \
    crop_box_max_x:='5.0' \
    crop_box_max_y:='20.0' \
    crop_box_max_z:='3.0' \
    leaf_size:=0.4 \
    node_name:='Airy_123'

