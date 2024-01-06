#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/common/log.sh
source $SCRIPT_DIR/../install/setup.bash 
source $SCRIPT_DIR/../../autoware-robobus/setup.bash 

function run_cali(){
    dir_path="$SCRIPT_DIR/output/output_cgi410_imu_param.yaml"
    
    if [ ! -e $dir_path ]; then
        log_error "Can't find imu's bag file:[$dir_path]"
        exit 1
    fi
    python3 "$SCRIPT_DIR/imu_intrinsic/parser.py"
}

function main(){
    ros2 launch $SCRIPT_DIR/imu_intrinsic/launch/imu_intrinsic_cali.launch.py
    run_cali
    log_info "Calibration successful, output [$SCRIPT_DIR/output/output_cgi410_imu_param.yaml]"
}
main