# Use the official NVIDIA base image with CUDA support
FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# Install Python 3.8.5 and other dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python3.8-venv \
    libgl1\
    libgl1-mesa-glx \
    libglib2.0-0\
    git\
    neovim\
    && apt-get clean

# Set Python 3.8 as the default python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install model library
RUN git clone https://github.com/shivahanifi/DAFormer-SCDD
WORKDIR /DAFormer-SCDD
# Install dependencies from requirements.txt, including PyTorch with CUDA support
RUN pip3 install --no-cache-dir -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
# Install mmcv-full==1.3.7 
RUN pip3 install mmcv-full==1.3.7


