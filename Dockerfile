FROM osrf/ros:melodic-desktop-full

LABEL maintainer="ozan.tokatli@ukaea.uk"

ENV NVIDIA_VISIBLE_DEVICES \
	${NVIDIA_VISIBLE_DEVICES:-all}

ENV NVIDIA_DRIVER_CAPABILITIES \
	${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

ARG DEBIAN_FRONTEND=noninteractive

# Change shell to bash
SHELL ["/bin/bash", "-c"]

# ROS workspace
ENV ROS_WS /workspace
RUN mkdir -p $ROS_WS/src
WORKDIR $ROS_WS

# Set Gazebo environment variable
ENV GAZEBO_MODEL_PATH ${ROS_WS}/src:${ROS_WS}/src/glovebox_gazebo/models:~/.gazebo/models

# Solve expired GPG key problem
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -

# For debugging
RUN apt-get update && apt-get install -y --no-install-recommends \
	tmux vim

# Install ROS dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
	python-catkin-tools \
	python3-pip \
	python3-setuptools \
	python3-venv \
	python3-wheel \
	ros-melodic-moveit \
	ros-melodic-industrial-trajectory-filters \
	ros-melodic-effort-controllers \
	ros-melodic-joint-trajectory-controller \
	ros-melodic-gripper-action-controller \
	ros-melodic-ros-control \
	ros-melodic-ros-controllers && \
	rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# Install ros_kortex
RUN mkdir -p ${ROS_WS}/src/ros_kortex
COPY ./ros_kortex ${ROS_WS}/src/ros_kortex
RUN python3 -m pip install conan && \
	conan config set general.revisions_enabled=1 && \
	conan profile new default --detect > /dev/null && \
	conan profile update settings.compiler.libcxx=libstdc++11 default && \
	source /opt/ros/$ROS_DISTRO/setup.bash && \
	rosdep install --from-paths src --ignore-src -y

# Setup glovebox models
RUN cd $ROS_WS/src && catkin_create_pkg glovebox_gazebo
COPY glovebox_gazebo/ $ROS_WS/src/glovebox_gazebo/
RUN source /opt/ros/$ROS_DISTRO/setup.bash && catkin_make

COPY entrypoint.sh /
COPY config.yaml /root/.ignition/fuel/config.yaml

ENTRYPOINT ["bash","/entrypoint.sh"]

CMD ["bash"]
