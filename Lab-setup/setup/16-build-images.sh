#!/bin/bash

echo "building Lab 2 Docker Image"
sudo systemctl start docker 
cd ~/github/Lab2-docker-debug 
sudo docker build -t glovebox:latest . 

echo "Building Telemetry Docker Image"
cd ~/github/Lab4-telemetry-service 
sudo docker build -t lab-telemetry-service:latest . 

cd

echo "Starting Telemetry Docker Image"
sudo docker run -d \
-p 8080:8080 \
--privileged \
--restart always \
--device /dev/i2c-1 \
--name pi-sense-hat \
lab-telemetry-service:latest