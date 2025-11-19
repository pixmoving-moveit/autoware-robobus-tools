#!/bin/bash

# 自动 source ROS2
if [ -f /opt/ros/humble/setup.bash ]; then
    source /opt/ros/humble/setup.bash
else
    echo "❌ 未找到 /opt/ros/humble/setup.bash"
    exit 1
fi

# 自动 source 工作空间
WS_PATH=~/home/pix/calibration_new/ws  

if [ -f $WS_PATH/install/setup.bash ]; then
    source $WS_PATH/install/setup.bash
else
    echo "❌ 未找到 $WS_PATH/install/setup.bash"
    exit 1
fi

### ---------------------------
### 参数检查
### ---------------------------

if [ $# -ne 1 ]; then
    echo "用法: ./calib_camera.sh <camera_name>"
    echo "例如: ./calib_camera.sh camera1"
    exit 1
fi

CAMERA=$1
echo "🔧 准备标定相机: $CAMERA"

### ---------------------------
### 运行 launch
### ---------------------------

ros2 launch calib_board calib_board.launch.py camera:=$CAMERA
