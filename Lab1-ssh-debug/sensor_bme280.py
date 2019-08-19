from datetime import datetime
import board
import digitalio
import busio
import adafruit_bme280
import fcntl
import random
import json
import time
import os


class Telemetry():
    def __init__(self):
        self.temperature = self.pressure = self.humidity = self.sensorLastEpoch = 0
        self.sensorlock = open("/tmp/sensor.lock", 'r+')
        self.i2c = busio.I2C(board.SCL, board.SDA)
        self.bme280 = None

        # take the system wide global lock
        # locking is done for lab as solution is multiuser
        fcntl.lockf(self.sensorlock, fcntl.LOCK_EX)
        retry = 0
        while retry < 5:
            try:
                self.bme280 = adafruit_bme280.Adafruit_BME280_I2C(
                    self.i2c, address=0x76)
                break
            except:
                retry += 1
                time.sleep(0.5)
                print('retrying sensor connect')
        else:
            print('Could not connect to sensor - check connection')
        fcntl.lockf(self.sensorlock, fcntl.LOCK_UN)

    def __read_sensor(self):
        # take the system wide global lock
        # locking is done for lab as solution is multiuser
        # Do not debug in this area
        try:
            fcntl.lockf(self.sensorlock, fcntl.LOCK_EX)

            self.sensorlock.seek(0)
            data = self.sensorlock.read()
            delta = 0

            if data != '':
                telemetry = json.loads(data)
                delta = int(time.time()) - telemetry.get('epoch')
                self.temperature = telemetry.get('temperature')
                self.pressure = telemetry.get('pressure')
                self.humidity = telemetry.get('humidity')

            # Was sensor read greater than 15 seconds ago?
            if data == '' or delta > 15:

                self.temperature = round(self.bme280.temperature, 1)
                self.pressure = round(self.bme280.pressure)
                self.humidity = round(self.bme280.humidity)

                telemetry = {
                    "temperature": self.temperature,
                    "pressure": self.pressure,
                    "humidity": self.humidity,
                    "epoch": int(time.time())
                }

                self.sensorlock.seek(0)
                self.sensorlock.truncate(0)
                self.sensorlock.write(json.dumps(telemetry))
                self.sensorlock.flush()

        except:
            print('Issue reading sensor')
        finally:
            fcntl.lockf(self.sensorlock, fcntl.LOCK_UN)

    def measure(self):
        # if sensor read less than 30 seconds ago then use cached data
        if (time.time() - self.sensorLastEpoch) < 30:
            self.sensorLastEpoch = int(time.time())
            return

        if self.bme280 is None:
            # BME Sensor not found so generate random data
            self.temperature = random.randrange(20, 25)
            self.pressure = random.randrange(1000, 1100)
            self.humidity = random.randrange(50, 70)
            return

        self.__read_sensor()

        return self.temperature, self.pressure, self.humidity
