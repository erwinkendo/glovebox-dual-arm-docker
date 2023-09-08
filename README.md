
# Glovebox Dual Arm Simulator

A docker container for simulating dual robotic arms inside a glovebox.

## Getting started

Clone the repository using:

```bash
git clone git@github.com:erwinkendo/glovebox-dual-arm-docker.git
```

## Running the Simulation

After getting the repository, together with an updated _ros_kortex_ folder, build the docker image and run a container.

### Linux

For easy building and running, you can use some ready scripts:

Build the container using the `./build.bash` [script](./build.bash).

Run the command `xhost +local:root` before running the container, using the `./run.bash` [script](./run.bash). Remember to run `xhost -local:root` after closing the container.

This depends on the _nvidia_ runtime being installed in your machine.

### Windows

You need to use a modified version of the commands available in `./build.bash` and  `./run.bash`.

**NOTE:** Performance under a Windows machine running Docker is orders of magnitude slower than in Linux (i.e., 2 FPS in Gazebo). Running docker from a WSL2 terminal should make things slightly faster.
If using Windows Insider Preview, try using Nvidia acceleration.

#### Build

Open a command window in your cloned repository and type:

```bash
docker build -t glovebox .
```

#### Run

Set an X server in your Windows PC, like the
[vcxsrv](https://sourceforge.net/projects/vcxsrv/). Remember to activate it, disabling OpenGL native support.

In the same command window, run:

```bash
docker run -it --name glovebox_simulator_2123 --rm --privileged -p 11311:11311 -e DISPLAY=host.docker.internal:0.0 -e QT_X11_NO_MITSHM=1 -e LIBGL_ALWAYS_INDIRECT=0 glovebox
```

You are welcome to change the port being mapped changing the number in `-p 11311:11311`.

## Notes

If you change your startup procedure to access the bash, for instance modifying **entrypoint.sh**, you can still run the simulation.

Source the ROS setup file `source devel/setup.bash` and then run the Gazebo simulation. This is not recommended, as the simulation is started by using four launch files. However, if you decide to use it, run the following in order:

```bash
# To start the glovebox environment
roslaunch glovebox_gazebo spawn_glovebox.launch
# To start the first Kinova arm
roslaunch glovebox_gazebo spawn_robot_A.launch
# To start the second Kinova arm
roslaunch glovebox_gazebo spawn_robot_B.launch
# To start an rviz instance
roslaunch glovebox_gazebo spawn_rviz.launch
```

If the glovebox or pedestal models are not loading, be sure you have the environmental variable GAZEBO_MODEL_PATH pointing at the catkin workspace (see line 22 of the `Dockerfile`).
