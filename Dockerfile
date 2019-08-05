FROM python:3.7-slim

# RUN apk add --update alpine-sdk

RUN apt-get update &&  apt-get install -y --no-install-recommends \
        build-essential \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get -y autoremove

RUN export PIP_DEFAULT_TIMEOUT=100 
RUN pip3 install --upgrade pip 
RUN pip3 install --upgrade setuptools 
RUN pip3 install ptvsd iotc RPI.GPIO adafruit-blinka adafruit-circuitpython-bme280

# Add the application
ADD app /app

EXPOSE 5679

# Set the working directory
WORKDIR /app

RUN ls /app

CMD ["python3","app.py"]

# docker run -it --device /dev/i2c-0 --device /dev/i2c-1 --rm --privileged mywebapp:latest