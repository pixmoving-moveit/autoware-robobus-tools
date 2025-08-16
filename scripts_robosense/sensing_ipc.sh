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
  echo "  ./sensing.sh [robot_state]"
  echo ""
  echo "    - robot_state : 启动传感器是否发布tf树 true | false, 默认不发布"
  echo ""
}

robot_state="${1:-false}"
autoware_robobus_calibration_path=$SCRIPT_DIR

ros2 launch $SCRIPT_DIR/launcher/sensor_driver_run.launch.xml \
  autoware_robobus_calibration_path:=$autoware_robobus_calibration_path\
  robot_state:=$robot_state 