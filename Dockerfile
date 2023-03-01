# Use an official ROS Noetic base image
FROM osrf/ros:noetic-desktop-full

# Update and upgrade packages
RUN apt-get update && \
    apt-get upgrade -y

# Install dependencies for velo2cam_calibration
RUN apt-get install -y \
    python3-pip \
    python3-catkin-tools \
    ros-noetic-opencv-apps \
    git \
    nano \
    tmux \
    wget

RUN pip install rospkg empy

# Clone the velo2cam_calibration package and build it
RUN mkdir -p /catkin_ws/src && \
    cd /catkin_ws && \
    catkin init && \
    catkin config --extend /opt/ros/noetic && \
    catkin build 

RUN bash -c "source /catkin_ws/devel/setup.bash"

COPY . /catkin_ws/src/velo2cam_calibration

RUN cd /catkin_ws && \
    catkin build velo2cam_calibration

# Source the ROS setup script
RUN echo "source /opt/ros/noetic/setup.bash" >> /root/.bashrc
RUN echo "source /catkin_ws/devel/setup.bash" >> /root/.bashrc

# Set the working directory to the catkin workspace
WORKDIR /catkin_ws

# Launch the bash shell by default
CMD ["/bin/bash"]
