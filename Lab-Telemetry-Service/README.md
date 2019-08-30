# Lab Telemetry Service

```bash
docker run -d \
-p 8080:8080 \
--restart always \
--device /dev/i2c-1 \
--name bme280 \
lab-telemetry-service:latest
```


```bash
docker run -it \
-p 8080:8080 \
--device /dev/i2c-1 \
balenalib/raspberrypi3:buster
```