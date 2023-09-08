#!/bin/bash

#XAUTH=/tmp/.docker.xauth
#if [ ! -f $XAUTH ]
#then
#    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
#    if [ ! -z "$xauth_list" ]
#    then
#        echo $xauth_list | xauth -f $XAUTH nmerge -
#    else
#        touch $XAUTH
#    fi
#    chmod a+r $XAUTH
#fi
#docker run -it \
#    --name="glovebox_simulator" \
#    --env="DISPLAY=$DISPLAY" \
#    --env="QT_X11_NO_MITSHM=1" \
#    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
#    --env="XAUTHORITY=$XAUTH" \
#    --volume="$XAUTH:$XAUTH" \
#    --runtime=nvidia \
#    gb

docker run -it \
    --name="glovebox_simulator_2123" \
    --rm --privileged \
    --net=host \
    --env=NVIDIA_VISIBLE_DEVICES=all \
    --env=NVIDIA_DRIVER_CAPABILITIES=all \
    --env=DISPLAY \
    --env=QT_X11_NO_MITSHM=1 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --runtime=nvidia \
    -e NVIDIA_VISIBLE_DEVICES=0 \
    glovebox
