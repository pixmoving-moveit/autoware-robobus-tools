#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

ros2 launch $SCRIPT_DIR/launcher/lidar2camera_cali.launch.xml 
