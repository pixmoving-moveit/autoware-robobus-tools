#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

# ros2 run tf2_ros static_transform_publisher 0.5, 0.0, 0.0, 0.0, 0.0, -0.1 map lidar_ft_base_link

ros2 run tf2_ros static_transform_publisher 0.5, 0.0, 0.0, -2.0, 3.14, -0.1 map lidar_fl_base_link