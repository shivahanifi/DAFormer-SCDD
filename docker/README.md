# Docker created for DAFromer to be used for SCDD

## Building the docker
```
docker build daformer-scdd .
```

## Run the docker
This to run the docker with gpu access and a shared folder. Do not forget `xhost +`  
```
sudo docker run --rm --gpus all -v /home/shiva/Documents/code/DAFormer-SCDD/share:/DAFormer-SCDD/share -it daformer-scdd
```
