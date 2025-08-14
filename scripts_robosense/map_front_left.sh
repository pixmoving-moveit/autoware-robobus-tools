#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $HOME/pix/robobus/autoware-robobus.master/install/setup.bash 

ros2 launch $SCRIPT_DIR/launcher/lidar/multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input_topic:=/sensing/lidar/front_left/points \
    crop_box_min_x:='-5.0' \
    crop_box_min_y:='-2.0' \
    crop_box_min_z:='-2.0' \
    crop_box_max_x:='2.0' \
    crop_box_max_y:='1.0' \
    crop_box_max_z:='2.0' \
    negativate_crop_box:='true' \
    initial_pose:='[2.0, 0.2, 1.7, 0.0, 3.14, 2.0]'\
    leaf_size:=0.4 \
    node_name:='Airy_122' \
    remover_initial_pose:='[1.121, 0.909, -0.488, -3.131, -0.058, 1.190]' 

