FROM nvidia/cuda:9.0-devel

ARG https_proxy
ARG http_proxy

########################
###  OPENCV INSTALL  ###
########################

ARG OPENCV_VERSION=4.0.0
ARG OPENCV_INSTALL_PATH=/usr/local/opencv

RUN apt-get update && \
        apt-get install -y \
		python-pip \
        build-essential \
        cmake \
        git \
        wget \
        unzip \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libjpeg-dev \
        libpng-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libpq-dev \
		libxine2-dev \
		libglew-dev \
		libtiff5-dev \
		zlib1g-dev \
		libjpeg-dev \
		libpng12-dev \
		libjasper-dev \
		libavcodec-dev \
		libavformat-dev \
		libavutil-dev \
		libpostproc-dev \
		libswscale-dev \
		libeigen3-dev \
		libtbb-dev \
		libgtk2.0-dev \
		pkg-config \
		python-dev \
		python-numpy \
		python3-dev \
		python3-numpy \
		&& rm -rf /var/lib/apt/lists/*


## Create install directory
## Force success as the only reason for a fail is if it exist

RUN mkdir -p $OPENCV_INSTALL_PATH; exit 0

WORKDIR /

## Single command to reduce image size
## Build opencv

RUN cd $OPENCV_INSTALL_PATH && wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
		unzip $OPENCV_VERSION.zip && rm -r $OPENCV_VERSION.zip
		 
		 
RUN cd $OPENCV_INSTALL_PATH && wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip && \
		unzip $OPENCV_VERSION.zip && rm -r $OPENCV_VERSION.zip
		 

RUN cd $OPENCV_INSTALL_PATH/opencv-$OPENCV_VERSION/ && mkdir build && cd build \
    && cmake -DBUILD_TIFF=ON \
       -DBUILD_opencv_java=OFF \
       -DBUILD_SHARED_LIBS=OFF \
       -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_INSTALL_PATH/opencv_contrib-$OPENCV_VERSION/modules \
       -DWITH_CUDA=ON \
       -DENABLE_FAST_MATH=1 \
       -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-9.0 \
       -DCUDA_ARCH_BIN='3.0 3.5 5.0 6.0 6.2' \
       -DCUDA_ARCH_PTX="" \
       -DCPU_DISPATCH=AVX,AVX2 \
       -DENABLE_PRECOMPILED_HEADERS=OFF \
       -DWITH_OPENGL=OFF \
       -DWITH_OPENCL=OFF \
       -DWITH_QT=OFF \
       -DWITH_IPP=ON \
       -DWITH_TBB=ON \
       -DFORCE_VTK=ON \
       -DWITH_EIGEN=ON \
       -DWITH_V4L=ON \
       -DWITH_XINE=ON \
       -DWITH_GDAL=ON \
       -DWITH_1394=OFF \
       -DWITH_FFMPEG=OFF \
       -DBUILD_PROTOBUF=OFF \
       -DBUILD_TESTS=OFF \
       -DBUILD_PERF_TESTS=OFF \
       -DCMAKE_BUILD_TYPE=RELEASE \
       -DCMAKE_INSTALL_PREFIX=$OPENCV_INSTALL_PATH \
    .. \
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install \
    && rm -r $OPENCV_INSTALL_PATH/opencv-$OPENCV_VERSION/build

RUN ln -s $OPENCV_INSTALL_PATH/opencv-$OPENCV_VERSION/3rdparty/ippicv/unpack/ippicv_lnx/lib/intel64/libippicv.a /usr/local/lib/libippicv.a
RUN tar cvzf opencv-$OPENCV_VERSION.tar.gz --directory=$OPENCV_INSTALL_PATH
