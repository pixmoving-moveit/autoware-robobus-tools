
import argparse
import os
import sys
import yaml


from ament_index_python.packages import get_package_share_directory
from launch import LaunchDescription
from launch_ros.actions import Node


def generate_launch_description():
    ld = LaunchDescription()
    
    common_config_path = os.path.join(
        os.getenv("HOME"), 
        "pix/parameter/sensor_kit", 
        "robobus_sensor_kit_description/intrinsic_parameters",
        "camera4.yaml")
    
    video_encoder_path = os.path.join(
        os.getenv("HOME"), 
        "pix/parameter/sensor_kit", 
        "robobus_sensor_kit_description/intrinsic_parameters",
        "encoder_params.yaml")
    
    ld.add_action(Node(
        package='isaac_ros_v4l2_camera', executable='isaac_ros_v4l2_camera_node_exe', output='screen',
        name="usb_cam_camera4_node",
        namespace='camera4',
        parameters=[
            {"common_config_path": common_config_path},
            {"video_encoder_path": video_encoder_path},
            ],
        ))
    return ld