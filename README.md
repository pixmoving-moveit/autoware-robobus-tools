
# robobus工具集
> 包含标定工具和建图工具

## 开始
### step-1 部署程序
```shell
cd ~/pix/robobus/
git clone -b livox https://github.com/pixmoving-moveit/autoware-robobus-tools.git autoware-robobus-tools.livox
cd autoware-robobus-tools.livox
mkdir src
vcs import src < calibration_tools.repos --recursive
source ~/pix/robobus/autoware-robobus.feature.PixRover1.1/install/setup.bash
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
colcon build  --cmake-args -DCMAKE_BUILD_TYPE=Release
```

### step-2 开始标定
