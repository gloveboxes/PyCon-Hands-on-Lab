FROM balenalib/raspberrypi3:buster


RUN apt-get update &&  apt-get install -y --no-install-recommends \
        python3-pip sense-hat \
        && rm -rf /var/lib/apt/lists/* \
        && apt-get -y autoremove


RUN export PIP_DEFAULT_TIMEOUT=100 
RUN pip3 install --upgrade pip && pip3 install --upgrade setuptools 
RUN pip3 install flask ptvsd 

# Add the application
ADD app /app
WORKDIR /app

ENV PYTHONUNBUFFERED=1

CMD ["python3","app.py"]

# docker run -it -p 3003:3000 --device /dev/i2c-0 --device /dev/i2c-1 --rm --privileged lab2-docker:latest 