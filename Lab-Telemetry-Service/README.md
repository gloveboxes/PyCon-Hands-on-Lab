# Lab Telemetry Service

```bash
docker run -d \
-p 8080:8080 \
--restart always \
--device /dev/i2c-0 --device /dev/i2c-1 \
--name bme280 \
lab-telemetry-service:latest
```
