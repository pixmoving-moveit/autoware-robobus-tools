#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $HOME/pix/robobus/autoware-robobus/install/setup.bash 

function print_help() {
  echo "启动传感器"
  echo ""
  echo "Usage:"
  echo "  ./sensing.sh [-robot_state] [-verify]"
  echo ""
  echo "    - robot_state : 启动传感器是否发布tf树"
  echo "    - verify : 标定完成后验证tf"
  echo ""
}

robot_state="${1:-true}"
autoware_robobus_calibration_path=$SCRIPT_DIR/..

ros2 launch $SCRIPT_DIR/launcher/sensor_driver_run.launch.xml robot_state:=$robot_state autoware_robobus_calibration_path:=$autoware_robobus_calibration_path