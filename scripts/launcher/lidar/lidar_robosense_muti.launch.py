from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    current_file = __file__
    current_dir = os.path.dirname(os.path.abspath(__file__))
    config_file = f"{current_dir}/robosense_config.yaml"
    
    return LaunchDescription([
        Node(
            namespace='rslidar_sdk', 
            package='rslidar_sdk', 
            executable='rslidar_sdk_node', 
            output='screen', 
            parameters=[{'config_path': config_file}]
        ),
    ])
