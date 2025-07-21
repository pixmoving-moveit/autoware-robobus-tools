#!/bin/bash
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
source $SCRIPT_DIR/../install/setup.bash 

# 临时生成一个子脚本内容
tmp_child_launcher=$(mktemp)

cmd0="$SCRIPT_DIR/map_front_top.sh"
cmd1="$SCRIPT_DIR/map_front_left.sh;  exec bash"
cmd2="$SCRIPT_DIR/map_front_right.sh; exec bash"
cmd3="$SCRIPT_DIR/map_rear_center.sh; exec bash"
cmd4="$SCRIPT_DIR/map_rear_top.sh;    exec bash"

cat << EOF > $tmp_child_launcher
#!/bin/bash

gnome-terminal --tab --title="map_front_left"  -- bash -c "$cmd1" 
gnome-terminal --tab --title="map_front_right" -- bash -c "$cmd2" 
gnome-terminal --tab --title="map_rear_center" -- bash -c "$cmd3" 
gnome-terminal --tab --title="map_rear_top"    -- bash -c "$cmd4" 

exec $cmd0
EOF

chmod +x "$tmp_child_launcher"

# 在一个新的终端中运行这个子脚本
gnome-terminal --window -- bash -c "$tmp_child_launcher; exec bash"

rm -f "$tmp_child_launcher"
