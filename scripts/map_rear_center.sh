#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $HOME/pix/robobus/$AUTOWARE_ROBOBUS_WORKSPACE/install/setup.bash 

ros2 launch  $SCRIPT_DIR/launcher/lidar/multi_lidar_calibration_ndt_map.launch.xml \
    pcd_path:=$SCRIPT_DIR/load_pcd/scans_down.pcd \
    input_topic:=/sensing/lidar/rear_center/points \
    initial_pose:='[-1.2, -1.5, 0.5, 0.0, 3.14, 0.0]'\
    crop_box_min_x:='0.0' \
    crop_box_min_y:='0.0' \
    crop_box_min_z:='0.0' \
    crop_box_max_x:='0.0' \
    crop_box_max_y:='0.0' \
    crop_box_max_z:='0.0' \
    leaf_size:=0.4 \
    node_name:='E1R_124' \
    remover_initial_pose:='[-1.917, -0.074, -1.521, 3.110,-0.052,-3.083]'
