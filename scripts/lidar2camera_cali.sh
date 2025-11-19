#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 
source $SCRIPT_DIR/../../autoware-robobus/install/setup.bash 

root_path=/home/nvidia/pix/ros2bag/lidar2camera/2024_07_24-16/output/rosbag2_2024_07_24-16_19_10/output
pcd_path=$root_path/output.pcd
image_path=$root_path/sensing_camera_camera${1:-1}_image_raw.output.png

gnome-terminal -t "camera_points_publisher" --tab -- bash -i -c "ros2 launch manual_lidar_camera_calibration camera_points_publisher.launch.xml image_path:=$image_path; exec bash;"
gnome-terminal -t "extrinsic_calibrator" --tab -- bash -i -c "ros2 launch manual_lidar_camera_calibration extrinsic_calibrator.launch.xml lidar_frame_id:=sensor_kit_base_link; exec bash;"