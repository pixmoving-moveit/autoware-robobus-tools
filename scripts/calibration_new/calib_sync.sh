#!/bin/bash

# ==========================================
# 车辆标定参数覆盖 + 内参矩阵更新 脚本
# ==========================================

SRC_DIR="/home/cjl/pix/parameter/sensor_kit/robobus_sensor_kit_description"
DST_DIR="/home/cjl/Videos/calibration_new/calib_data/config"

SRC_EX="$SRC_DIR/extrinsic_parameters"
SRC_IN="$SRC_DIR/intrinsic_parameters"

DST_EX="$DST_DIR/extrinsic_parameters"
DST_IN="$DST_DIR/intrinsic_parameters"

# 创建备份目录
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_DIR="$DST_DIR/backup_$TIMESTAMP"

echo "🔧 开始替换车辆标定参数..."
echo "来源目录:       $SRC_DIR"
echo "目标目录:       $DST_DIR"
echo "备份目录:       $BACKUP_DIR"
echo "-------------------------------------------"

# 检查源目录是否存在
if [ ! -d "$SRC_DIR" ]; then
    echo "❌ 源目录不存在: $SRC_DIR"
    exit 1
fi

# 创建备份
mkdir -p "$BACKUP_DIR"
cp -r "$DST_EX" "$BACKUP_DIR/" 2>/dev/null
cp -r "$DST_IN" "$BACKUP_DIR/" 2>/dev/null
echo "✓ 已备份旧参数到: $BACKUP_DIR"

# 替换 extrinsic
if [ -d "$SRC_EX" ]; then
    rm -rf "$DST_EX"
    cp -r "$SRC_EX" "$DST_EX"
    echo "✓ 已替换 extrinsic_parameters"
else
    echo "⚠ 源目录缺少 extrinsic_parameters"
fi

# 替换 intrinsic
if [ -d "$SRC_IN" ]; then
    rm -rf "$DST_IN"
    cp -r "$SRC_IN" "$DST_IN"
    echo "✓ 已替换 intrinsic_parameters"
else
    echo "⚠ 源目录缺少 intrinsic_parameters"
fi

echo "-------------------------------------------"
echo "🔧 开始更新 rectification_matrix 为 camera_matrix..."
echo

# 检查 yq
if ! command -v yq &> /dev/null; then
    echo "❌ yq 未安装，请执行: sudo apt install yq"
    exit 1
fi

# 处理 camera0–camera7
for i in {0..7}; do
    FILE="$DST_IN/camera${i}_params.yaml"

    if [ ! -f "$FILE" ]; then
        echo "⚠ 未找到文件: $FILE"
        continue
    fi

    echo "→ 更新: camera${i}_params.yaml"

    # 将 camera_matrix.data 覆盖 rectification_matrix.data
    yq -i '
      .rectification_matrix.data = .camera_matrix.data |
      .rectification_matrix.rows = 3 |
      .rectification_matrix.cols = 3
    ' "$FILE"

done

echo "-------------------------------------------"
echo "🎉 参数替换 + 矩阵更新完成!"
