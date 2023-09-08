#!/bin/bash

# set -e
# 
# nohup Xvfb :1 -screen 0 1024x768x16 &> xvfb.log &
# DISPLAY=:1.0
# export DISPLAY

export ROS_MASTER_URI=http://$(hostname --ip-address):11311
export ROS_HOSTNAME=$(hostname --ip-address)

source "/opt/ros/${ROS_DISTRO}/setup.bash"
source "${ROS_WS}/devel/setup.bash"

roslaunch glovebox_gazebo spawn_glovebox.launch  &

sleep 120

roslaunch glovebox_gazebo spawn_robot_A.launch  &

sleep 120

roslaunch glovebox_gazebo spawn_robot_B.launch  &

sleep 60

roslaunch glovebox_gazebo spawn_rviz.launch  &

# Load the Gazebo simulator
#roslaunch glovebox_gazebo spawn.launch

#sleep 10

#cd ~/gzweb
#npm start &


#sleep 30

#python /home_robot.py

# Run ROS core
#roscore &

#sleep 15


exec "$@"

# roslaunch kortex_gazebo spawn_kortex_robot.launch

