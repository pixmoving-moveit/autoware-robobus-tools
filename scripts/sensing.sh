#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $SCRIPT_DIR/../../autoware-robobus/install/setup.bash 

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

ros2 launch robobus_sensor_kit_calibration sensing_all.launch.xml robot_state:=$robot_state 