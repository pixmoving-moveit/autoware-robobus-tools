#!/bin/python3
import os
import yaml
import json
import logging

COLOR_RED = '\033[1;31m'
COLOR_GREEN = '\033[1;32m'
COLOR_YELLOW = '\033[1;33m'
COLOR_BLUE = '\033[1;34m'
COLOR_PURPLE = '\033[1;35m'
COLOR_CYAN = '\033[1;36m'
COLOR_GRAY = '\033[1;37m'
COLOR_RESET = '\033[0m'
LOG_FORMAT = f'{COLOR_GREEN}[%(levelname)s]{COLOR_RESET} %(message)s'
logging.basicConfig(format=LOG_FORMAT, level=logging.INFO)

class ParserYaml:
    def __init__(self):
        self.script_path = os.path.dirname(os.path.abspath(__file__))

        self.read_camera_intrinsic_file()
        self.revise_camera_intrinsic()
        self.write_yaml_file()


    def read_camera_intrinsic_file(self):
        path = os.path.join(self.script_path, "..", "output", "cgi_cgi410_imu_param.yaml")
        try:
            with open(path, "r") as f:
                self.imu_cail_yaml = yaml.load(f, Loader=yaml.FullLoader)
        except Exception as e:
            with open(path, "r") as f:
                for i in range(2 - 1):
                    f.readline()
                yaml_str = ''.join(f.readlines())
                self.imu_cail_yaml = yaml.load(yaml_str, Loader=yaml.FullLoader)

        # print(self.imu_cail_yaml["Gyr"]["avg-axis"]["gyr_n"])  # imuGyrNoise
        # print(self.imu_cail_yaml["Gyr"]["avg-axis"]["gyr_w"])  # imuGyrBiasN
        # print(self.imu_cail_yaml["Acc"]["avg-axis"]["acc_n"])  # imuAccNoise
        # print(self.imu_cail_yaml["Acc"]["avg-axis"]["acc_w"])  # imuAccBiasN

    def revise_camera_intrinsic(self):
        self.param_yaml={}
        self.param_yaml["/**"] = {"ros__parameters": {}}
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_stddev_xx"] = self.imu_cail_yaml["Gyr"]["x-axis"]["gyr_n"]
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_stddev_yy"] = self.imu_cail_yaml["Gyr"]["y-axis"]["gyr_n"]
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_stddev_zz"] = self.imu_cail_yaml["Gyr"]["z-axis"]["gyr_n"]
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_offset_x"] = self.imu_cail_yaml["Gyr"]["x-axis"]["gyr_w"]
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_offset_y"] = self.imu_cail_yaml["Gyr"]["y-axis"]["gyr_w"]
        self.param_yaml["/**"]["ros__parameters"]["angular_velocity_offset_z"] = self.imu_cail_yaml["Gyr"]["z-axis"]["gyr_w"]

    
    def write_yaml_file(self):
        path = os.path.join(self.script_path, "..", "output", "imu_corrector.param.yaml")
        with open(path, "w") as f:
            yaml.dump(self.param_yaml, f)

if __name__== "__main__":
    yaml2yaml = ParserYaml()
    logging.info(f'convert network:')
