#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $SCRIPT_DIR/../../autoware-robobus/install/setup.bash 

if [[ "$1" == "true" ]]; then
  ros2 launch robobus_sensor_kit_calibration interactive.launch.xml   # "参数值为True，执行操作。"
else
  ros2 launch robobus_sensor_kit_calibration tag_based.launch.xml
fi



