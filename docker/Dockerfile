# Use the official NVIDIA base image with CUDA support
FROM nvidia/cuda:11.0.3-base-ubuntu20.04

# Install Python 3.8.5 and other dependencies
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3.8 \
    python3.8-dev \
    python3-pip \
    python3.8-venv \
    libgl1\
    libgl1-mesa-glx \
    libglib2.0-0\
    git\
    wget\
    tar\
    unzip\
    neovim\
    eog\
    && apt-get clean


# Install model library
RUN git clone https://github.com/shivahanifi/DAFormer-SCDD
WORKDIR /DAFormer-SCDD

# Install dependencies from requirements.txt, including PyTorch with CUDA support
RUN pip3 install --no-cache-dir -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html && \
    pip3 install mmcv-full==1.3.7 && \
    pip3 install gdown 

# Create necessary directories
RUN mkdir -p pretrained work_dirs

# Download demo requirements and store in work_dirs directory
WORKDIR /DAFormer-SCDD/work_dirs
RUN gdown https://drive.google.com/uc?id=1pG3kDClZDGwp1vSTEXmTchkGHmnLQNdP
RUN tar -xzvf 211108_1622_gta2cs_daformer_s0_7f24c.tar.gz 

# Set the PYTHONPATH to include project directory
ENV PYTHONPATH=/DAFormer-SCDD:$PYTHONPATH
