import os
from launch import LaunchDescription
from launch_ros.actions import Node
from ament_index_python.packages import get_package_share_directory
import yaml
def generate_launch_description():
    camera_name="camera6"
    config_path = f"{os.getenv('HOME')}/pix/parameter/sensor_kit/robobus_sensor_kit_description/intrinsic_parameters/{camera_name}.yaml"
    
    parameters={}
    with open(config_path, 'r') as yaml_file:
        parameters = yaml.safe_load(yaml_file)
    parameters["frame_id"] = f"{parameters['frame_id']}/cali"
    
    node = Node(
            package='ros2_v4l2_jetcam',
            executable='ros2_v4l2_jetcam_node_exe',
            name=f"ros2_v4l2_jetcam_node_exe_{camera_name}",
            namespace=camera_name,
            output='screen',
            parameters=[parameters],
            remappings=[
                ('image_raw', 'camera_image'),
            ],
        )
   
    return LaunchDescription([node,
                              ])
