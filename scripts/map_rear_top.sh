#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $HOME/pix/robobus/$AUTOWARE_ROBOBUS_WORKSPACE/install/setup.bash 

ros2 launch  $SCRIPT_DIR/launcher/lidar/multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input_topic:=/sensing/lidar/rear_top/points \
    crop_box_min_x:='0.0' \
    crop_box_min_y:='0.0' \
    crop_box_min_z:='0.0' \
    crop_box_max_x:='0.0' \
    crop_box_max_y:='0.0' \
    crop_box_max_z:='0.0' \
    initial_pose:='[0.5, -1.0, 1.5, 0.0, -0.1, 3.16]'\
    leaf_size:=0.4 \
    node_name:='M1P_121' \
    remover_initial_pose:='[-0.882, -0.000, 0.015, -0.011, 0.020, -3.072]'
