FROM nvidia/cuda:9.0-devel

ARG https_proxy
ARG http_proxy

########################
###  OPENCV INSTALL  ###
########################

ARG OPENCV_VERSION=4.0.0
ARG OPENCV_INSTALL_PATH=/usr/local

RUN apt-get update && apt-get install -y \
        build-essential \
        cmake \
        curl \
        git \
        wget \
        unzip \
        yasm \
        ffmpeg \
        libgstreamer1.0-dev \
        gstreamer1.0-plugins-base \
        gstreamer1.0-plugins-good \
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
		libpng12-dev \
		libavcodec-dev \
		libavutil-dev \
		libpostproc-dev \
		libeigen3-dev \
		libtbb-dev \
		libgtk2.0-dev \
		pkg-config \
		python-dev \
		python-numpy \
		python3.5-dev \
		python3.5-numpy \
		&& rm -rf /var/lib/apt/lists/*


RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3.5 get-pip.py && \
    rm get-pip.py


RUN mkdir -p $OPENCV_INSTALL_PATH/opencv; exit 0


RUN cd $OPENCV_INSTALL_PATH/opencv && wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.zip && \
		unzip $OPENCV_VERSION.zip && rm -r $OPENCV_VERSION.zip
		 
		 
RUN cd $OPENCV_INSTALL_PATH/opencv && wget https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.zip && \
		unzip $OPENCV_VERSION.zip && rm -r $OPENCV_VERSION.zip
		 
RUN apt-get update && apt-get install -y --no-install-recommends libgstreamer-plugins-base1.0-dev gstreamer1.0-libav \
		gstreamer1.0-doc \
		gstreamer1.0-tools

#RUN list=$(apt-cache --names-only search ^gstreamer1.0-* | awk '{ print $1 }' | grep -v gstreamer1.0-hybris)
#RUN apt-get install -y --no-install-recommends $list
		
RUN apt-get update -y && apt-get install -y pkg-config libwebp-dev 
		 

RUN cd $OPENCV_INSTALL_PATH/opencv/opencv-$OPENCV_VERSION/ && mkdir build && cd build \
    && cmake -DBUILD_TIFF=ON \
       -DBUILD_opencv_java=OFF \
       -DBUILD_SHARED_LIBS=OFF \
       -DOPENCV_EXTRA_MODULES_PATH=$OPENCV_INSTALL_PATH/opencv/opencv_contrib-$OPENCV_VERSION/modules \
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
       -DWITH_GSTREAMER=ON \
       -DWITH_FFMPEG=ON \
       -DBUILD_PROTOBUF=ON \
       -DBUILD_TESTS=OFF \
       -DBUILD_PERF_TESTS=OFF \
       -DCMAKE_BUILD_TYPE=RELEASE \
       -DCMAKE_INSTALL_PREFIX=$OPENCV_INSTALL_PATH \
    .. \
    && make -j8 && make install \
    && /bin/bash -c 'echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf' && \
    cd .. \
    && rm -r $OPENCV_INSTALL_PATH/opencv/opencv-$OPENCV_VERSION/build && ldconfig

RUN ln -s $OPENCV_INSTALL_PATH/opencv/opencv-$OPENCV_VERSION/3rdparty/ippicv/unpack/ippicv_lnx/lib/intel64/libippicv.a /usr/local/lib/libippicv.a
#RUN tar cvzf opencv-$OPENCV_VERSION.tar.gz --directory=$OPENCV_INSTALL_PATH
