FROM ubuntu:20.04
# FROM nvidia/cuda:11.3.1-cudnn8-devel-ubuntu20.04

WORKDIR /root

#--------------#
# Localization #
#--------------#

RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y tzdata
ENV TZ=Asia/Tokyo

RUN apt-get install -y locales fonts-takao && locale-gen ja_JP.UTF-8
ENV LANG=ja_JP.UTF-8
ENV LANGUAGE=ja_JP:ja
ENV LC_ALL=ja_JP.UTF-8
RUN localedef -f UTF-8 -i ja_JP ja_JP.utf8

#-----------#
# Dev Tools #
#-----------#

# Install CMake 3.21.6 for g2o
# CLion supports CMake 2.8.11~3.21.x
RUN apt-get install -y git build-essential libssl-dev
RUN git clone https://gitlab.kitware.com/cmake/cmake.git -b v3.21.6
RUN mkdir /root/cmake/build
WORKDIR /root/cmake/build
RUN ../bootstrap && make -j$(nproc) && make install
WORKDIR /root

RUN apt-get install -y \
      gcc \
      g++ \
      gdb \
      clang \
      make \
      ninja-build \
      autoconf \
      automake \
      locales-all \
      dos2unix \
      rsync \
      tar \
      python

#---------------#
# Source Builds #
#---------------#

# libboost-dev is not enough for PCL
RUN apt-get install -y libboost-all-dev libeigen3-dev 

# glog
RUN git clone https://github.com/google/glog.git -b v0.5.0
RUN mkdir /root/glog/build
WORKDIR /root/glog/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# gflags    
RUN git clone https://github.com/gflags/gflags.git -b v2.2.2
RUN mkdir /root/gflags/build
WORKDIR /root/gflags/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# gtest
RUN git clone https://github.com/google/googletest.git -b release-1.11.0
RUN mkdir /root/googletest/build
WORKDIR /root/googletest/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# ceres-solver
RUN apt-get install -y libatlas-base-dev libsuitesparse-dev
RUN git clone https://github.com/ceres-solver/ceres-solver.git -b 2.1.0
RUN mkdir /root/ceres-solver/build
WORKDIR /root/ceres-solver/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# g2o
RUN apt-get install -y libsuitesparse-dev qtdeclarative5-dev qt5-qmake libqglviewer-dev-qt5
RUN git clone https://github.com/RainerKuemmerle/g2o.git
RUN mkdir /root/g2o/build
WORKDIR /root/g2o/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# Sophus
RUN git clone https://github.com/strasdat/Sophus.git
RUN mkdir /root/Sophus/build
WORKDIR /root/Sophus/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# matplotlib-cpp
RUN apt-get install -y python3-matplotlib python3-numpy python3-dev wget
RUN wget https://github.com/lava/matplotlib-cpp/raw/master/matplotlibcpp.h -P /usr/local/include

RUN apt-get install -y libopencv-dev

# PCL
RUN apt-get install -y libusb-1.0-0-dev libflann-dev libvtk7-dev libpcap-dev
RUN git clone https://github.com/PointCloudLibrary/pcl.git -b pcl-1.12.1
RUN mkdir /root/pcl/build
WORKDIR /root/pcl/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# pybind11
RUN git clone https://github.com/pybind/pybind11.git
RUN mkdir /root/pybind11/build
WORKDIR /root/pybind11/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

# PROJ
RUN apt-get install -y sqlite3 libsqlite3-dev
RUN git clone https://github.com/OSGeo/PROJ.git -b 9.0.0
RUN mkdir /root/PROJ/build
WORKDIR /root/PROJ/build
RUN cmake .. && make -j$(nproc) && make install
WORKDIR /root

#--------------#
# gdb printers #
#--------------#

# for OpenCV Mat debugger
RUN apt-get install -y python3-pip
RUN pip3 install numpy
# Place gdb scripts
COPY gdbinit.sh /root/.gdbinit
COPY gdb/ /root/gdb/
