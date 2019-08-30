# Lab Telemetry Service

```bash
docker run -d \
-p 8080:8080 \
--privileged \
--restart always \
--device /dev/i2c-1 \
--name pi-sense-hat \
lab-telemetry-service:latest
```
