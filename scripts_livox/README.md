# 脚本说明

## 数据采集

### step-1: 启动传感器

> 启动后，会弹出两个rviz界面，分别是lidar和camera，请检查传感器是否都启动

```bash
cd ~/pix/robobus/autoware-robobus-calibration/scripts
./sensing.sh
```

### step-2: 开始录制

> 会录制`autoware-robobus-calibration/scripts/config/lidar2camera.txt`这个文件里的话题

```bash
cd ~/pix/robobus/autoware-robobus-calibration/scripts
./data_collection.sh
```

### step-3: 编辑录制配置文件夹`config` (可选，不重要)

> 如果有新的话题需要录制

```bash
# 如果有新的录制话题，可以在config文件夹里创建test.txt文件，按照一行一个话题
# 执行下面指令开始录制
./data_collection.sh test.txt
```
