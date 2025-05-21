
#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../../install/setup.bash 

ros2 service call /map_save std_srvs/srv/Trigger 

pcl_viewer scans.pcd

read -p "是否部署覆盖scripts/load_pcd(Y/N): " answer
answer=$(echo "$answer" | tr 'a-z' 'A-Z')  # 转换为大写（防止小写 y）
if [ "$answer" == "Y" ]; then
  echo "确定部署覆盖scripts/load_pcd"
elif [ "$answer" == "N" ]; then
  echo "取消部署覆盖scripts/load_pcd"
  exit 0
else
  echo "输入无效，请输入 Y 或 N。"
  exit 1
fi

mv scans.pcd $SCRIPT_DIR/../load_pcd/scans_down.pcd
# pcl_voxel_grid scans.pcd scans_down.pcd -leaf 0.5
# pcl_viewer scans_down.pcd
