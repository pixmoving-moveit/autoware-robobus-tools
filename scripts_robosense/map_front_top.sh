#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $HOME/pix/robobus/autoware-robobus.master/install/setup.bash 

ros2 launch   $SCRIPT_DIR/launcher/lidar/multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input_topic:=/sensing/lidar/front_top/points \
    initial_pose:='[2.0, -1.0, 2.0, 0.0, 0.05, 0.03]' \
    crop_box_min_x:='0.0' \
    crop_box_min_y:='0.0' \
    crop_box_min_z:='0.0' \
    crop_box_max_x:='0.0' \
    crop_box_max_y:='0.0' \
    crop_box_max_z:='0.0' \
    leaf_size:=0.4 \
    node_name:='M1P_120' \
    remover_initial_pose:='[0.882, -0.000, -0.015, 0.015, 0.036, 0.053]'
