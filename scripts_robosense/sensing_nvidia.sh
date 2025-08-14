#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

# 使用旧的可执行文件，导致rviz黑屏
rm -rf $SCRIPT_DIR/launcher/__pycache__
rm -rf $SCRIPT_DIR/launcher/camera/__pycache__
sleep 1

source $HOME/pix/robobus/autoware-robobus.master/install/setup.bash

function print_help() {
  echo "启动传感器"
  echo ""
  echo "Usage:"
  echo "  ./sensing.sh [camera_name]"
  echo ""
  echo "    - camera_name : 启动那个相机"
  echo ""
}

camera_name="${1:-camera0}"
autoware_robobus_calibration_path=$SCRIPT_DIR/..

ros2 launch $SCRIPT_DIR/launcher/camera.launch.xml \
  autoware_robobus_calibration_path:=$autoware_robobus_calibration_path \
  camera_name:=$camera_name