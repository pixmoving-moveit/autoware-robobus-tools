#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

camera_name=$1
# 使用正则表达式检查变量是否符合 "部署cameraX" 格式
if ! [[ "$camera_name" =~ ^camera[0-9]$ ]]; then
  echo "$camera_name 不符合格式, 请输入cameraX"
  exit 1
fi

autoware_robobus_calibration_path=$SCRIPT_DIR/..

ros2 launch $SCRIPT_DIR/launcher/lidar2camera_cali.launch.xml \
  camera_name:=$camera_name \
  autoware_robobus_calibration_path:=$autoware_robobus_calibration_path

