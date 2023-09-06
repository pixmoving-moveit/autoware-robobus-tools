#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

function log_info() {
  echo -e "\033[32m[INFO] $*\033[0m[\033[32m\u2714\033[0m]"
}

function log_warning() {
  echo -e "\033[33m[WARNING] $*\033[0m[\033[33m⚠️\033[0m]"
}

function log_error() {
  echo -e "\033[31m[ERROR] $*\033[0m[\033[31m\xE2\x9C\x97\033[0m]"
}

parent_frame=''
child_frame='[]'
output_yaml_file='sensors_calibration.yaml'

cat<<EOF
a: robobus sensor_top 到 os_lidar_fl os_lidar_fr os_lidar_rl os_lidar_rr
b: robobus os_lidar_ancillary 到 cemera_top
c: robobus os_lidar_ancillary 到 cemera_front
d: robobus sensor_top 到 os_lidar_ancillary
EOF

read -p "请输入标定序号(a-c): " choice
case "$choice" in
    a)
        parent_frame='sensor_top'
        child_frame='[os_lidar_fl,os_lidar_fr,os_lidar_rl,os_lidar_rr]'
        output_yaml_file='sensor_top2lidar-4.yaml'
    ;;

    b)
        parent_frame='os_lidar_ancillary'
        child_frame='[cemera_top]'
        output_yaml_file='os_lidar_ancillary2cemera_top.yaml'
    ;;

    c)
        parent_frame='os_lidar_ancillary'
        child_frame='[cemera_front]'
        output_yaml_file='os_lidar_ancillary2cemera_front.yaml'
    ;;

    d)
        parent_frame='sensor_top'
        child_frame='[os_lidar_ancillary]'
        output_yaml_file='sensor_top2os_lidar_ancillary.yaml'
    ;;

    *)
    log_warning "请输入a-c的序号."
    exit 1
    ;;
esac


ros2 launch tf_tree_to_yaml tf_tree_to_yaml.launch.py \
    parent_frame:=$parent_frame \
    child_frame:=$child_frame \
    output_yaml_file:=$output_yaml_file


if [ $? -eq 0 ]; then
  log_info "成功输出：$SCRIPT_DIR/$output_yaml_file"
else
  log_error "执行出错 执行出错 执行出错"
fi