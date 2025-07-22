#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
YAML_PATH="$HOME/pix/parameter/sensor_kit/robobus_sensor_kit_description/extrinsic_parameters/sensor_kit_calibration.yaml"
MAP_YAML_PATH="$HOME/pix/parameter/sensor_kit/robobus_sensor_kit_description/extrinsic_parameters/lidar_from_map.yaml"

# ✅ 自定义菜单目标
declare -A TARGET_MAP=(
  [7]="camera7/camera_link"
  [6]="camera6/camera_link"
  [5]="camera5/camera_link"
  [4]="camera4/camera_link"
  [3]="camera3/camera_link"
  [2]="camera2/camera_link"
  [1]="camera1/camera_link"
  [0]="camera0/camera_link"
  [8]="lidar_all"
)

MENU_ORDER=(7 6 5 4 3 2 1 0 8)

# ✅ 显示菜单
echo "请选择要更新的TF目标："
for key in "${MENU_ORDER[@]}"; do
  echo "$key) ${TARGET_MAP[$key]}"
done
echo "q) 退出"

# ✅ 用户输入
read -p "请输入选项: " choice
if [[ "$choice" == "q" || "$choice" == "Q" ]]; then
  echo "✅ 已退出"
  exit 0
fi

child_frame="${TARGET_MAP[$choice]}"
if [[ -z "$child_frame" ]]; then
  echo "❌ 无效选项: $choice"
  exit 1
fi



# ✅ 如果 child 是 lidar_ 开头，则额外保存 map → child 的 TF 到新 YAML 文件
if [[ "$child_frame" == "lidar_all" ]]; then
  lidar_list=(
    lidar_fl_base_link
    lidar_fr_base_link
    lidar_ft_base_link
    lidar_rt_base_link
    lidar_rear_base_link
  )

  for lidar_frame in "${lidar_list[@]}"; do
    echo "🔄 正在更新 $lidar_frame 到 $YAML_PATH"

    # ✅ 写入主 calibration 文件
    python3 $SCRIPT_DIR/launcher/tf/tf_to_yaml_updater.py \
      --parent sensor_kit_base_link \
      --child "$lidar_frame" \
      --yaml "$YAML_PATH"

    # ✅ 写入 map → lidar 到独立 extrinsic 文件
    python3 $SCRIPT_DIR/launcher/tf/tf_to_yaml_updater.py \
      --parent map \
      --child "$lidar_frame" \
      --yaml "$MAP_YAML_PATH"
  done

  echo "✅ 所有 LIDAR 更新完成"
  exit 0

else
  # ✅ 执行主 TF 更新（sensor_kit_base_link → child_frame）
  python3 $SCRIPT_DIR/launcher/tf/tf_to_yaml_updater.py \
    --parent sensor_kit_base_link \
    --child "$child_frame" \
    --yaml "$YAML_PATH"
fi
