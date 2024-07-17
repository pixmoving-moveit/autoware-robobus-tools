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

function rosbag_to_pcds(){
  local rosbag_path=$1
  local topic=$2

  if [ -z "$rosbag_path" ]; then
    log_error "rosbag_to_pcds()函数: rosbag_path变量是空的"
    return
  fi

  check_topic_in_bag $topic $rosbag_path
  if [ $? -eq 0 ]; then
    log_info "话题存在: $topic"
  else
    log_warning "话题不存在: $topic"
    return 
  fi

  ros2 launch $SCRIPT_DIR/launcher/rosbag2_to_pcds.launch.xml \
    path:=$rosbag_path \
    lidar_topic:=$topic 

  mkdir $rosbag_path"_pcd_png"
  
  outpcds=$rosbag_path"_pcds"
  check_suffix_files $outpcds '.pcd'
  if [ $? -eq 0 ]; then
    log_info "合并pcd,输出output.pcd"
    cd $outpcds
    pcl_concatenate_points_pcd *.pcd
    mv $rosbag_path"_pcds/output.pcd" $rosbag_path"_pcd_png"
  fi
}

function rosbag_to_pngs(){
  log_info 
  local rosbag_path=$1
  local topics=$2

  if [ -z "$rosbag_path" ]; then
    log_error "rosbag_to_pngs()函数: rosbag_path变量是空的"
    return
  fi

  eval "imag_topics=(${topics//[\[\]\' ]/})"
  # 遍历image_topics列表并调用check_topic_in_bag函数
  for topic in "${imag_topics[@]}"; do
    check_topic_in_bag $topic $rosbag_path
    if [ $? -eq 0 ]; then
      log_info "话题存在: $topics"
    else
      log_warning "话题不存在: $topics"
      return
    fi
  done

  ros2 launch $SCRIPT_DIR/launcher/rosbag2_to_pngs.launch.xml \
    path:=$rosbag_path \
    image_topics:=$topics 
  
  mkdir $rosbag_path"_pcd_png"

  outpngs=$rosbag_path"_pngs"
  check_suffix_files $outpngs '.png'
  if [ $? -eq 0 ]; then
    log_info "开始输出output.png"
    cd $outpngs
    last_file=$(ls -1 | tail -n 1)
    mv $last_file output.png
    mv $rosbag_path"_pngs/output.png" $rosbag_path"_pcd_png"
  fi
}

function process()
{
  local path=$root/$1

  local lidar_topic_1=$2
  local image_topics_1=$3

  log_info "start work: "$path 

  rosbag_to_pcds $path $lidar_topic_1
  rosbag_to_pngs $path $image_topics_1
}

function main()
{
  lidar_topic="/sensing/lidar/concatenated/pointcloud_unfilter1111"
  image_topics="['/sensing/camera/camera6/image_raw']"
  
  array=($(ls $root | grep rosbag2_))
  for element in "${array[@]}"
  do
    echo  $element
    log_info "start: $element"
    process $element $lidar_topic $image_topics
    log_info "--------------------------------------------"
  done

  find $root -type d -regextype egrep -regex '.*/ros2bag.*[0-9]+$' | while read dir_path; do
    rosbag_name=$(basename "$dir_path")
    pngs_name="$root/output/$rosbag_name"_pngs
    pcds_name="$root/output/$rosbag_name"_pcds
    png_pcd_name="$root/output/$rosbag_name"_pcd_png
    
    if [ -d "$pngs_name" ]; then
      log_info "================================================"
      mv "$root/$rosbag_name"_pngs/* $pngs_name
      rm -r "$root/$rosbag_name"_pngs
    else
      log_warning "文件夹不存在: $pngs_name"
      mkdir $root/output
      mv "$root/$rosbag_name"_pngs/ $root/output
    fi

    if [ -d "$pcds_name" ]; then
      log_info "================================================"
      mv "$root/$rosbag_name"_pcds/* $pcds_name
      rm -r "$root/$rosbag_name"_pcds 
    else
      log_warning "文件夹不存在: $pcds_name"
      mkdir $root/output
      mv "$root/$rosbag_name"_pcds/ $root/output
    fi

    if [ -d "$png_pcd_name" ]; then
      log_info "================================================"
      mv "$root/$rosbag_name"_pcd_png/* $png_pcd_name
      rm -r "$root/$rosbag_name"_pcd_png
    else
      log_warning "文件夹不存在: $pcds_name"
      mkdir $root/output
      mv "$root/$rosbag_name"_pcd_png/ $root/output
    fi
  done
}

main 

# 使用方法: ./to_pcd_png.sh <root_path>
# <root_path>: ros2bag文件夹根目录
# 例如：./scripts/to_pcd_png.sh ~/pix/ros2bag/livox
