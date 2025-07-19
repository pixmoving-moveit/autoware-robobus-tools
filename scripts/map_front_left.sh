#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch  multi_lidar_calibration multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input/target_pointcloud:=/sensing/lidar/front_left/points \
    output/cropped_target_pointcloud:=/sensing/lidar/front_left/cropped_points \
    crop_box_min_x:='-1.0' \
    crop_box_min_y:='-1.0' \
    crop_box_min_z:='-2.0' \
    crop_box_max_x:='1.0' \
    crop_box_max_y:='1.0' \
    crop_box_max_z:='2.0' \
    negativate_crop_box:='true' \
    initial_pose:='[2.0, 0.2, 1.7, 0.0, 3.14, 1.95]'\
    leaf_size:=0.4 \
    node_name:='Airy_122'
