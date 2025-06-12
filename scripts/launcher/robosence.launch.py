from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    config_file = os.path.join(get_package_share_directory('robobus_sensor_kit_launch'), 'config', 'robosence_config.yaml')
    
    return LaunchDescription([
        Node(
            namespace='rslidar_sdk', 
            package='rslidar_sdk', 
            executable='rslidar_sdk_node', 
            output='screen', 
            parameters=[{'config_path': config_file}]
        ),
    ])
