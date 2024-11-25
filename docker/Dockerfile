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
    wget\
    tar\
    unzip\
    neovim\
    && apt-get clean

# Set Python 3.8 as the default python version
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

# Install model library
RUN git clone https://github.com/shivahanifi/DAFormer-SCDD
WORKDIR /DAFormer-SCDD

## Download the MiT ImageNet weights (b3-b5) from SegFormer OneDrive and put them in 'pretrained/'
#RUN wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1pG3kDClZDGwp1vSTEXmTchkGHmnLQNdP' -O pretrained/mit_imagenet_b3_b5_weights.tar.gz \
#    && tar -xzvf pretrained/mit_imagenet_b3_b5_weights.tar.gz -C pretrained/ \
#    && rm pretrained/mit_imagenet_b3_b5_weights.tar.gz
#
## Download the DAFormer checkpoint on GTA→Cityscapes and extract to 'work_dirs/'
#RUN wget -O work_dirs/pretrained_models.zip "https://connecthkuhk-my.sharepoint.com/personal/xieenze_connect_hku_hk/_layouts/15/onedrive.aspx?id=%2Fpersonal%2Fxieenze%5Fconnect%5Fhku%5Fhk%2FDocuments%2Fsegformer%2Fpretrained%5Fmodels&ga=1&download=1"\
#    && unzip work_dirs/pretrained_models.zip -d work_dirs/ \
#    && rm work_dirs/pretrained_models.zip
#

# Install dependencies from requirements.txt, including PyTorch with CUDA support
RUN pip3 install --no-cache-dir -r requirements.txt -f https://download.pytorch.org/whl/torch_stable.html
# Install mmcv-full==1.3.7 
RUN pip3 install mmcv-full==1.3.7


# Create necessary directories
RUN mkdir -p pretrained work_dirs

