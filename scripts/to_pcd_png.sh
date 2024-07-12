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


source $SCRIPT_DIR/../install/setup.bash 

root=$1

function process()
{
  path=$root/$1

  lidar_topic="/front/livox/points"
  image_topics="['/gmsl/rect_resize/image_raw']"

  ros2 launch $SCRIPT_DIR/launcher/rosbag2_to_pcd_png.launch.xml \
      path:=$path \
      lidar_topic:=$lidar_topic \
      image_topics:=$image_topics

  cd $path"_pcds"
  pcl_concatenate_points_pcd *.pcd

  cd $path"_pngs"
  last_file=$(ls -1 | tail -n 1)
  mv $last_file output.png

  mkdir $path"_pcd_png"
  mv $path"_pngs/output.png" $path"_pcd_png"
  mv $path"_pcds/output.pcd" $path"_pcd_png"
}

function main()
{
  array=($(ls $root | grep rosbag2_2024))
  for element in "${array[@]}"
  do
    echo  $element
    log_info "start: $element"
    process $element
    log_info "--------------------------------------------"
  done

  rm -rf $root/output
  mkdir $root/output
  cd $root
  mv *p* $root/output
}

main 

# 使用方法: ./to_pcd_png.sh <root_path>
# <root_path>: ros2bag文件夹根目录