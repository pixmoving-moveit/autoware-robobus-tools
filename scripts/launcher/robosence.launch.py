from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():

    rviz_config=get_package_share_directory('rslidar_sdk')+'/rviz/rviz2.rviz'

    config_file = '' # your config file path
    current_file = os.path.abspath(__file__)
    current_dir = os.path.dirname(current_file)
    user_config_path = os.path.join(current_dir, "robosence_config.yaml")

    return LaunchDescription([
      Node(
          namespace='rslidar_sdk', 
          package='rslidar_sdk', 
          executable='rslidar_sdk_node', 
          output='screen', 
          parameters=[{'config_path': config_file}]),
    ])