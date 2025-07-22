#!/usr/bin/env python3
import rclpy
import tf2_ros
import yaml
import time
import re
import os
from rclpy.node import Node
from geometry_msgs.msg import TransformStamped
from scipy.spatial.transform import Rotation as R

def is_camera_link(s):
    return re.fullmatch(r'camera[0-9]/camera_link', s) is not None

class TFExtractor(Node):
    def __init__(self, parent_frame, child_frame, yaml_path):
        super().__init__('tf_extractor_node')
        self.parent_frame = parent_frame
        self.child_frame = child_frame
        self.yaml_path = yaml_path

        self.tf_buffer = tf2_ros.Buffer()
        self.listener = tf2_ros.TransformListener(self.tf_buffer, self)

        self.start_time = time.time()
        self.max_duration = 10.0  # 最多等待10秒
        self.done = False

        self.timer = self.create_timer(1.0, self.lookup_and_save)

    def lookup_and_save(self):
        try:
            child_frame = self.child_frame
            if is_camera_link(self.child_frame):
                child_frame = f"{child_frame}/cali"
            
            trans: TransformStamped = self.tf_buffer.lookup_transform(
                self.parent_frame,
                child_frame,
                rclpy.time.Time())
        except Exception as e:
            elapsed = time.time() - self.start_time
            if elapsed > self.max_duration:
                self.get_logger().error(
                    f"❌ 超过最大等待时间 {self.max_duration}s，仍未获取 TF: {e}")
                self.done = True
                self.destroy_timer(self.timer)
            else:
                self.get_logger().warn(
                    f"等待 TF 中（{int(elapsed)}s）: {e}")
            return

        # 成功获取 TF 后处理
        t = trans.transform.translation
        q = trans.transform.rotation

        rotation = R.from_quat([q.x, q.y, q.z, q.w])
        roll, pitch, yaw = rotation.as_euler('xyz', degrees=False)

        transform_data = {
            'x': float(round(t.x, 16)),
            'y': float(round(t.y, 16)),
            'z': float(round(t.z, 16)),
            'roll': float(round(roll, 16)),
            'pitch': float(round(pitch, 16)),
            'yaw': float(round(yaw, 16))
        }
        
        self.update_yaml_file(self.yaml_path, self.child_frame, transform_data)
        self.get_logger().info(
            f"✅ 已更新 {self.child_frame} 的转换信息到 {self.yaml_path}")

        self.destroy_timer(self.timer)
        self.done = True

    def update_yaml_file(self, yaml_file, target_key, new_data):
        try:
            if not os.path.exists(yaml_file):
                content = {}
            else:
                with open(yaml_file, 'r') as f:
                    content = yaml.safe_load(f)
        except Exception as e:
            self.get_logger().error(f"读取 YAML 文件失败: {e}")
            return

        if 'sensor_kit_base_link' not in content:
            content['sensor_kit_base_link'] = {}

        content['sensor_kit_base_link'][target_key] = new_data

        try:
            with open(yaml_file, 'w') as f:
                yaml.dump(content, f, default_flow_style=False, sort_keys=False)
        except Exception as e:
            self.get_logger().error(f"写入 YAML 文件失败: {e}")


def main():
    import argparse
    parser = argparse.ArgumentParser(description='获取 TF 并更新 sensor_kit_calibration.yaml')
    parser.add_argument('--parent', required=True, help='父坐标系')
    parser.add_argument('--child', required=True, help='子坐标系')
    parser.add_argument('--yaml', required=True, help='YAML 文件路径')
    args = parser.parse_args()

    rclpy.init()
    node = TFExtractor(args.parent, args.child, args.yaml)

    while rclpy.ok() and not node.done:
        rclpy.spin_once(node)

    node.destroy_node()
    rclpy.shutdown()


if __name__ == '__main__':
    main()
