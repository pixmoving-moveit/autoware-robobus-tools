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
if [ ! -e "$root" ]; then
  log_error "路径不存在: $root 请输入: ./to_pcd_png.sh <root_path>"
  exit 1
elif [ ! -d "$root" ]; then
  log_error "路径存在，但这不是一个文件夹 请输入: ./to_pcd_png.sh <root_path>"
  exit 1
else
  log_info 输入地址: $root
fi

check_topic_in_bag() {
  local topic_name=$1
  local bag_path=$2

  # 检查bag路径是否存在
  if [ ! -e "$bag_path" ]; then
    log_error "bag路径不存在"
    return 1
  fi

  # 获取bag信息并检查是否包含话题
  if ros2 bag info "$bag_path" | grep -q "$topic_name"; then
      log_info "话题 '$topic_name' 存在于bag '$bag_path' 中"
      return 0
  else
      log_error "话题 '$topic_name' 不存在于bag '$bag_path' 中"
      return 1
  fi
}

check_suffix_files() {
  local directory=$1
  local suffix=$2

  # 检查路径是否存在且是文件夹
  if [ ! -d "$directory" ]; then
    log_error "路径不存在或不是一个文件夹: $directory"
    return 1
  fi

  # 查找路径下是否存在后缀为 $suffix 的文件
  if ls "$directory"/*$suffix 1> /dev/null 2>&1; then
    log_info "路径 '$directory' 下存在后缀为 $suffix 的文件"
    return 0
  else
    log_error "路径 '$directory' 下不存在后缀为 $suffix 的文件"
    return 1
  fi
}

function process()
{
  path=$root/$1

  lidar_topic="/front/livox/points"
  image_topics="['/sensing/camera/camera0/image_raw']"

  check_topic_in_bag $lidar_topic $path
  if [ $? -eq 0 ]; then
    log_info "话题存在: $lidar_topic"
    is_lidar_topic=ture
  else
    log_warning "话题不存在: $lidar_topic"
    is_lidar_topic=flase
  fi

  eval "imag_topics=(${image_topics//[\[\]\' ]/})"
  # 遍历image_topics列表并调用check_topic_in_bag函数
  for topic in "${imag_topics[@]}"; do
    check_topic_in_bag $topic $path
    if [ $? -eq 0 ]; then
      log_info "话题存在: $lidar_topic"
      is_image_topics=ture
    else
      log_warning "话题不存在: $lidar_topic"
      is_image_topics=flase
    fi
  done
  

  ros2 launch $SCRIPT_DIR/launcher/rosbag2_to_pcd_png.launch.xml \
      path:=$path \
      lidar_topic:=$lidar_topic \
      image_topics:=$image_topics \
      is_image_topics:=$is_image_topics
      is_lidar_topic:=$is_lidar_topic

  mkdir $path"_pcd_png"
  
  outpcds=$path"_pcds"
  check_suffix_files $outpcds '.pcd'
  if [ $? -eq 0 ]; then
    log_info "合并pcd,输出output.pcd"
    cd $outpcds
    pcl_concatenate_points_pcd *.pcd
    mv $path"_pcds/output.pcd" $path"_pcd_png"
  fi
 

  outpngs=$path"_pngs"
  check_suffix_files $outpngs '.png'
  if [ $? -eq 0 ]; then
    log_info "开始输出output.png"
    cd $outpngs
    last_file=$(ls -1 | tail -n 1)
    mv $last_file output.png
    mv $path"_pngs/output.png" $path"_pcd_png"
  fi
  
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
  mv *_pcd* $root/output
  mv *_png* $root/output
}

main 

# 使用方法: ./to_pcd_png.sh <root_path>
# <root_path>: ros2bag文件夹根目录
# 例如：./scripts/to_pcd_png.sh ~/pix/ros2bag/livox
