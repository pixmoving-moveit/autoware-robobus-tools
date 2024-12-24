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
  
  outpcds=$rosbag_path"_pcds"
  check_suffix_files $outpcds '.pcd'
  if [ $? -eq 0 ]; then
    log_info "合并pcd,输出output.pcd"
    cd $outpcds
    pcl_concatenate_points_pcd *.pcd
    cd -
  fi
}

function topic_to_string()
{
  local original_string=$1
  local modified_string=$(echo $original_string | sed 's/\([^\/]\)\//\1_/g; s/^\///')
  echo $modified_string
}
function rosbag_to_pngs(){
  
  local rosbag_path=$1

  if [ -z "$rosbag_path" ]; then
    log_error "rosbag_to_pngs()函数: rosbag_path变量是空的"
    return
  fi
  
  local image_topics="["
  # 循环遍历数组并打印每个元素
  for topic in "${image_topics_list[@]}"; do
    image_topics+="'"$topic"',"

    check_topic_in_bag $topic $rosbag_path
    if [ $? -eq 0 ]; then
      log_info "话题存在: $topic"
    else
      log_warning "话题不存在: $topic"
      return 1
    fi
  done

  image_topics="${image_topics%,}"
  image_topics+="]"
  
  log_info $image_topics
  
  pngs_out_path="$rosbag_path"_pngs

  ros2 launch $SCRIPT_DIR/launcher/rosbag2_to_pngs.launch.xml \
    in_path:=$rosbag_path \
    out_path:=$pngs_out_path \
    image_topics:=$image_topics 

  outpngs=$rosbag_path"_pngs"

  find "$outpngs" -mindepth 1 -maxdepth 1 -type d | while read dir; do
    cd $dir 

    dir_name=$(basename "$dir")
    check_suffix_files $dir '.png'
    if [ $? -eq 0 ]; then
      log_info "$dir_name".output.png文件重命名
      last_file=$(ls $dir | tail -n 1)
      mv $last_file "$dir_name".output.png
    fi

    cd - 
  done
  
}

function process()
{
  local path=$root/$1

  local lidar_topic_1=$2

  rosbag_to_pcds $path $lidar_topic_1
  rosbag_to_pngs $path $image_topics_list
}

function test(){
  local -n image_topics_list_1=$1
  local image_topics="["
  # 循环遍历数组并打印每个元素
  for topic in "${image_topics_list_1[@]}"; do
    image_topics+="'"$topic"',"
  done
  image_topics="${image_topics%,}"
  image_topics+="]"
  
  log_info $image_topics
}

function move_output()
{ 
  ros2bag_name=$1

  log_info "--------------------------------------------"
  log_info "移动output-结果文件 start"
  
  mkdir $root/output/$ros2bag_name
  mkdir $root/output/$ros2bag_name/output
  mv  $root/*_p* $root/output/$ros2bag_name

  find $root/output/$ros2bag_name -mindepth 1  -type f -name '*output*' | while read file_path; do
    mv $file_path $root/output/$ros2bag_name/output
  done

  log_info "移动output-结果文件 end"
  log_info "--------------------------------------------"
}

function main()
{
  rm -r $root/output
  mkdir $root/output

  local lidar_topic="/sensing/lidar/concatenated/pointcloud_unfilter"

  declare -a image_topics_list=(
    '/sensing/camera/camera0/camera_image' 
    '/sensing/camera/camera1/camera_image' 
    '/sensing/camera/camera2/camera_image'
    '/sensing/camera/camera3/camera_image'
    '/sensing/camera/camera4/camera_image'
    '/sensing/camera/camera5/camera_image'
    '/sensing/camera/camera6/camera_image'
    )
  
  find $root -mindepth 1 -maxdepth 1 -type d -regextype egrep -regex '.*/ros2bag.*[0-9]+$' | while read dir_path; do
    element=$(basename "$dir_path")
    # 提取pcd和png，并重命名
    log_info "start: $element"
    process $element $lidar_topic

    # 把结果整理到output下
    move_output $element
    log_info "--------------------------------------------"
  done

  
}

main 

#使用方法: ./to_pcd_png.sh root_path
#root_path: ros2bag文件夹根目录
#例如：./scripts/to_pcd_png.sh ~/pix/ros2bag/livox
