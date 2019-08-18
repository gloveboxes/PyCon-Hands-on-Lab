from flask import render_template
from datetime import datetime
import board
import digitalio
import busio
import adafruit_bme280
import fcntl
import random


class Telemetry():
    def __init__(self):
        self.sensorLock = '/tmp/sensor.local'

        self.i2c = busio.I2C(board.SCL, board.SDA)
        try:
            with open(self.sensorLock, 'w') as sensorlock:
                # minimise time here as this is a system wide global lock
                # locking is done for lab as solution is multiuser
                fcntl.lockf(sensorlock, fcntl.LOCK_EX)
                try:
                    self.bme280 = adafruit_bme280.Adafruit_BME280_I2C(self.i2c, address=0x76)
                except:
                    self.bme280 = None

    def read_sensor(self):
        temperature = 0
        pressure = 0
        humidity = 0

        # minimise time here as this is a system wide global lock
        # locking is done for lab as solution is multiuser
        with open(self.sensorLock, 'w') as sensorlock:
            fcntl.lockf(sensorlock, fcntl.LOCK_EX)
            temperature = round(self.bme280.temperature, 1)
            pressure = round(self.bme280.pressure)
            humidity = round(self.bme280.humidity)

        return temperature, pressure, humidity

    def render_telemetry(self):
        now = datetime.now()
        formatted_now = now.strftime("%A, %d %B, %Y at %X")

        title = "Raspberry Pi Environment Data"

        if self.bme280 is None:
            # BME Sensor not found so generate random data
            temperature = random.randrange(20, 25)
            pressure = random.randrange(1000, 1100)
            humidity = random.randrange(50, 70)
        else:
            temperature, pressure, humidity = read_sensor()

        # Do sensible range checking for sensor data
        if -10 <= temperature <= 60 and 800 <= pressure <= 1500 and 0 <= humidity <= 100:
            html = render_template('index.html', title=title,
                                   temperature=temperature, pressure=pressure,
                                   humidity=humidity)
        else:
            html = None

        return html
