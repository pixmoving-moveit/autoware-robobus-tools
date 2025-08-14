#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $HOME/pix/robobus/autoware-robobus.master/install/setup.bash 

ros2 launch   $SCRIPT_DIR/launcher/lidar/multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input_topic:=/sensing/lidar/front_right/points \
    initial_pose:='[2.0, -2.0, 1.7, 0.0, 3.14, -2.05]'\
    crop_box_min_x:='-2.0' \
    crop_box_min_y:='-2.0' \
    crop_box_min_z:='-4.0' \
    crop_box_max_x:='1.0' \
    crop_box_max_y:='2.0' \
    crop_box_max_z:='3.0' \
    leaf_size:=0.4 \
    node_name:='Airy_123' \
    remover_initial_pose:='[1.224, -0.819, -0.465, 3.127, 0.011, -1.054]'

