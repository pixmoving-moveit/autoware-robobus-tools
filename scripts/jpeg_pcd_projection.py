#!/usr/bin/env python3

import os
import sys
import rclpy
import numpy as np
import cv2
import open3d as o3d
import yaml
from rclpy.node import Node
from scipy.spatial.transform import Rotation as R
from sensor_msgs.msg import PointCloud2, CompressedImage
from cv_bridge import CvBridge
import message_filters
import struct
from rclpy.qos import QoSProfile, ReliabilityPolicy

# 相机映射
camera_name = sys.argv[1]
save_root_path = sys.argv[2]

camera_name_map = {
  'CAM_FRONT': 'camera1',
  'CAM_BACK': 'camera2',
  'CAM_FRONT_LEFT': 'camera3',
  'CAM_FRONT_RIGHT': 'camera4',
  'CAM_BACK_LEFT': 'camera5',
  'CAM_BACK_RIGHT': 'camera6',
}

if(len(sys.argv)!=3):
    print("2 arguments needed: camera_name, save_root_path")
    exit(1)
if (os.path.exists(sys.argv[2])==False):
    print("dataset not exists, Input again!")
    exit(1)
if (sys.argv[1] not in camera_name_map.keys()):
    print(camera_name_map.keys())
    print("camera index not exists, Input again!")
    exit(1)
    
camera_topic_map = {
  'CAM_FRONT': '/electronic_rearview_mirror/front_3mm/camera_image_jpeg',
  'CAM_BACK': '/electronic_rearview_mirror/rear_3mm/camera_image_jpeg',
  'CAM_FRONT_LEFT': '/electronic_rearview_mirror/front_left/camera_image_jpeg',
  'CAM_FRONT_RIGHT': '/electronic_rearview_mirror/front_right/camera_image_jpeg',
  'CAM_BACK_LEFT': '/electronic_rearview_mirror/rear_left/camera_image_jpeg',
  'CAM_BACK_RIGHT': '/electronic_rearview_mirror/rear_right/camera_image_jpeg',
}

# 固定路径：标定文件
home = os.path.expanduser("~")
sensor_kit_file = os.path.join(home, "pix/parameter/sensor_kit/robobus_sensor_kit_description/extrinsic_parameters/sensor_kit_calibration.yaml")
sensor_base_file = os.path.join(home, "pix/parameter/sensor_kit/robobus_sensor_kit_description/extrinsic_parameters/sensors_calibration.yaml")
camera_intrinsic_file = os.path.join(home, f"pix/parameter/sensor_kit/robobus_sensor_kit_description/intrinsic_parameters/{camera_name_map[camera_name]}_params.yaml")

def load_yaml(path):
    with open(path, 'r') as f:
        return yaml.load(f, Loader=yaml.FullLoader)

def get_M1_M2(sensor_kit_data, sensor_base_data, intrinsic, cam_name):
    K = np.array(intrinsic['camera_matrix']['data']).reshape(3, 3)
    M1 = np.eye(4)
    M1[:3, :3] = K

    frame = f"{camera_name_map[cam_name]}/camera_link"
    euler = [sensor_kit_data['sensor_kit_base_link'][frame][k] for k in ['roll', 'pitch', 'yaw']]
    trans = [sensor_kit_data['sensor_kit_base_link'][frame][k] for k in ['x', 'y', 'z']]
    R1 = R.from_euler('xyz', euler).as_matrix()
    T1 = np.eye(4)
    T1[:3, :3] = R1
    T1[:3, 3] = trans

    euler = [sensor_base_data['base_link']['sensor_kit_base_link'][k] for k in ['roll', 'pitch', 'yaw']]
    trans = [sensor_base_data['base_link']['sensor_kit_base_link'][k] for k in ['x', 'y', 'z']]
    R2 = R.from_euler('xyz', euler).as_matrix()
    T2 = np.eye(4)
    T2[:3, :3] = R2
    T2[:3, 3] = trans

    M2 = np.linalg.inv(T1) @ np.linalg.inv(T2)
    return M1, M2

def pointcloud2_to_array(msg):
    # 解析字段
    fmt = 'fff' + 'f'  # xyz + intensity
    point_step = msg.point_step
    offset = [f.offset for f in msg.fields]
    data = np.frombuffer(msg.data, dtype=np.uint8).reshape(-1, point_step)
    result = []
    for p in data:
        x, y, z, intensity = struct.unpack_from(fmt, p.tobytes())
        result.append([x, y, z, intensity])
    return np.array(result)

def undistort(img, K, D):
    h, w = img.shape[:2]
    map1, map2 = cv2.initUndistortRectifyMap(K, D, None, K, (w, h), 5)
    return cv2.remap(img, map1, map2, interpolation=cv2.INTER_LINEAR)

def jet_colormap(intensity, min_val=0, max_val=150):
    t = (intensity - min_val) / (max_val - min_val)
    t = max(0.0, min(1.0, t))

    if t < 0.25:
        r, g, b = 0, int(4 * t * 255), 255
    elif t < 0.5:
        r, g, b = 0, 255, int((1 - 4 * (t - 0.25)) * 255)
    elif t < 0.75:
        r, g, b = int(4 * (t - 0.5) * 255), 255, 0
    else:
        r, g, b = 255, int((1 - 4 * (t - 0.75)) * 255), 0

    return int(b), int(g), int(r)

def project_lidar(points, img, M1, M2):
    coords = np.hstack((points[:, :3], np.ones((points.shape[0], 1))))
    P = (M1 @ M2) @ coords.T
    P = P.T

    valid_mask = P[:, 2] > 0
    P = P[valid_mask]
    valid_points = points[valid_mask]

    P[:, 0] /= P[:, 2]
    P[:, 1] /= P[:, 2]

    h, w = img.shape[:2]
    mask = (P[:, 0] > 0) & (P[:, 0] < w) & (P[:, 1] > 0) & (P[:, 1] < h)

    return P[mask], valid_points[mask][:, -1]

def draw_projection(img_rgb, proj, intensity):
    img = img_rgb.copy()
    for p, i in zip(proj, intensity):
        x, y = int(p[0]), int(p[1])
        color = jet_colormap(i, min_val=1, max_val=155)
        cv2.circle(img, (x, y), 2, color=color, thickness=1)
    return img.astype(np.uint8)

class LidarImageProjector(Node):
    def __init__(self):
        super().__init__('lidar_image_projector')
        self.bridge = CvBridge()

        self.intrinsic = load_yaml(camera_intrinsic_file)
        self.sensor_kit = load_yaml(sensor_kit_file)
        self.sensor_base = load_yaml(sensor_base_file)
        self.M1, self.M2 = get_M1_M2(self.sensor_kit, self.sensor_base, self.intrinsic, camera_name)

        self.K = np.array(self.intrinsic['camera_matrix']['data']).reshape(3, 3)
        self.D = np.array(self.intrinsic['distortion_coefficients']['data']).astype(np.float32)

        # 同步订阅
        self.latest_image = None
        self.latest_pc = None
        self.image_stamp = None
        self.pc_stamp = None
        self.processed = False

        qos_profile = QoSProfile(
            reliability=ReliabilityPolicy.BEST_EFFORT,
            depth=10
        )
        
        self.sub_pc = self.create_subscription(
            PointCloud2,
            '/sensing/lidar/concatenated/pointcloud',
            self.pc_callback,
            qos_profile
        )

        self.sub_img = self.create_subscription(
            CompressedImage,
            camera_topic_map[camera_name],
            self.image_callback,
            10  # 图像默认 QoS 一般是 reliable
        )

        self.timer = self.create_timer(0.05, self.try_process_once)  # 20Hz 检查

    def image_callback(self, msg):
        self.latest_image = msg
        self.image_stamp = msg.header.stamp.sec + msg.header.stamp.nanosec * 1e-9

    def pc_callback(self, msg):
        self.latest_pc = msg
        self.pc_stamp = msg.header.stamp.sec + msg.header.stamp.nanosec * 1e-9

    def try_process_once(self):
        if self.processed:
            return

        if self.latest_image is None or self.latest_pc is None:
            return

        self.get_logger().info(f"{abs(self.image_stamp - self.pc_stamp)}")

        img = self.bridge.compressed_imgmsg_to_cv2(self.latest_image)
        img = cv2.resize(img, (1920, 1080))
        img = undistort(img, self.K, self.D)

        points = pointcloud2_to_array(self.latest_pc)
        proj, intensity = project_lidar(points, img, self.M1, self.M2)
        img_proj = draw_projection(img, proj, intensity)

        # cv2.namedWindow("Projection", cv2.WINDOW_NORMAL)
        # cv2.resizeWindow("Projection", 960, 540)
        # cv2.imshow("Projection", img_proj)
        # cv2.waitKey(1)
        
        save_path = os.path.join(save_root_path, f"lidar_projection_{camera_name.lower()}.jpeg")
        cv2.imwrite(save_path, img_proj)
        self.get_logger().info(f"✅ 投影图已保存至：{save_path}")
        self.timer.cancel()
        self.sub_pc.destroy()
        self.sub_img.destroy()

        self.processed = True

def main(args=None):
    rclpy.init(args=args)
    node = LidarImageProjector()
    try:
        while rclpy.ok():
            rclpy.spin_once(node, timeout_sec=0.1)
            if node.processed:
                break
    finally:
        node.destroy_node()
        rclpy.shutdown()

main()
