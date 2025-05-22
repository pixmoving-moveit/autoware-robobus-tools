#!/bin/bash

# 检查网络是否通
check_network() {
  local ip="$1"
  local count="${2:-1}"

  if ping -c "$count" -W 1 "$ip" > /dev/null 2>&1; then
    echo "✅ 网络畅通: $ip"
    return 0
  else
    echo "❌ 无法连接: $ip"
    return 1
  fi
}

check_ros2_topic() {
  local topic="$1"
  local timeout_sec="${2:-3}"

  # 捕获输出与返回码
  output=$(timeout "$timeout_sec" ros2 topic echo --once "$topic" 2>&1)
  ret=$?

  # 情况 1：正常收到数据（退出码是0，输出不为空）
  if [[ $ret -eq 0 && -n "$output" ]]; then
    echo "✅ 收到数据: $topic"
    return 0

  # 情况 2：阻塞超时（timeout 会返回124）
  elif [[ $ret -eq 124 ]]; then
    echo "⏳ 超时未收到数据: $topic"
    return 1

  # 情况 3：ros2 命令出错（话题不存在等）
  else
    echo "❌ 错误: $topic"
    return 2
  fi
}



# 示例用法（可注释掉）
check_network "192.168.1.120"
check_network "192.168.1.121"
check_network "192.168.1.122"
check_network "192.168.1.123"
check_network "192.168.1.124"
check_network "192.168.2.102"

check_ros2_topic "/sensing/lidar/front_left/points"
check_ros2_topic "/sensing/lidar/front_right/points"
check_ros2_topic "/sensing/lidar/front_top/points"
check_ros2_topic "/sensing/lidar/rear_center/points"
check_ros2_topic "/sensing/lidar/rear_top/points "
