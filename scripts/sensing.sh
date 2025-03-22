#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $HOME/pix/robobus/autoware-robobus/install/setup.bash 

function print_help() {
  echo "启动传感器"
  echo ""
  echo "Usage:"
  echo "  ./sensing.sh [robot_state] [camera_name]"
  echo ""
  echo "    - robot_state : 启动传感器是否发布tf树 true | false"
  echo "    - camera_name : 启动那个相机"
  echo ""
}

robot_state="${1:-false}"
camera_name="${2:-camera0}"
autoware_robobus_calibration_path=$SCRIPT_DIR/..

ros2 launch $SCRIPT_DIR/launcher/sensor_driver_run.launch.xml \
  autoware_robobus_calibration_path:=$autoware_robobus_calibration_path\
  robot_state:=$robot_state \
  camera_name:=$camera_name