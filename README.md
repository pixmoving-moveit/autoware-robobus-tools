
# robobus工具集
> 包含标定工具和建图工具

## 开始
### step-1 部署程序 -- 标定
```shell
cd ~/pix/robobus/
git clone -b livox https://github.com/pixmoving-moveit/autoware-robobus-tools.git autoware-robobus-tools.robosense
cd autoware-robobus-tools.robosense
mkdir src
vcs import src < calibration_tools.repos --recursive
source ~/pix/robobus/autoware-robobus.dev-PixRover1.2_1.5-v1.0/install/setup.bash 
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release
```

### step-2 部署程序 -- 建图

```shell
cd ~/pix/robobus/
git clone -b livox https://github.com/pixmoving-moveit/autoware-robobus-tools.git autoware-robobus-tools.robosense
cd autoware-robobus-tools.robosense
mkdir src
vcs import src < calibration_tools.repos --recursive
colcon build --cmake-args -DCMAKE_BUILD_TYPE=Release --packages-select livox_sdk2 livox_ros_driver2 fast_lio
```