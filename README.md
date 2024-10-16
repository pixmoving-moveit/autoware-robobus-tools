
```shell
cd ~/pix/robobus/
git clone -b feature/livox https://github.com/pixmoving-moveit/robobus_sensor_kit_calibration_script.git autoware-robobus-calibration
cd autoware-robobus-calibration
vcs import src < calibration_tools.repos --recursive
source ~/pix/robobus/autoware-robobus/install/setup.bash
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release
```