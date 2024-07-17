#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

function log_info() {
  echo -e "\033[32m[INFO] $*\033[0m[\033[32m\u2714\033[0m]"
}

function log_warning() {
  echo -e "\033[33m[WARNING] $*\033[0m[\033[33m⚠️\033[0m]"
}

function log_error() {
  echo -e "\033[31m[ERROR] $*\033[0m[\033[31m\xE2\x9C\x97\033[0m]"
}

source $HOME/pix/robobus/autoware-robobus/install/setup.bash 

timestamp=$(date +"%Y_%m_%d-%H")
mkdir -p $HOME/pix/ros2bag/lidar2camera/$timestamp
cd $HOME/pix/ros2bag/lidar2camera/$timestamp

ros2 bag record --max-cache-size 3221225472 --max-bag-size 2147483648 $(cat ${1:-$SCRIPT_DIR/config/lidar2camera.txt})