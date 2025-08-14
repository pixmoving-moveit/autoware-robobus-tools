
#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../../install/setup.bash 

ros2 service call /map_save std_srvs/srv/Trigger 

timestamp=$(date +"%Y%m%d%H%M%S")
mv scans.pcd scans_$timestamp.pcd
pcl_viewer scans.pcd