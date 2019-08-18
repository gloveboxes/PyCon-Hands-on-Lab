from datetime import datetime
import board
import digitalio
import busio
import adafruit_bme280
import fcntl
import random


class Telemetry():
    def __init__(self):
        self.sensorLock = '/tmp/sensor.lock'

        self.i2c = busio.I2C(board.SCL, board.SDA)
        with open(self.sensorLock, 'w') as sensorlock:
            # minimise time here as this is a system wide global lock
            # locking is done for lab as solution is multiuser
            fcntl.lockf(sensorlock, fcntl.LOCK_EX)
            try:
                self.bme280 = adafruit_bme280.Adafruit_BME280_I2C(
                    self.i2c, address=0x76)
            except:
                self.bme280 = None
            sensorlock.close()

    def read_sensor(self):
        temperature = pressure = humidity = 0

        # minimise time here as this is a system wide global lock
        # locking is done for lab as solution is multiuser
        with open(self.sensorLock, 'w') as sensorlock:
            fcntl.lockf(sensorlock, fcntl.LOCK_EX)
            temperature = round(self.bme280.temperature, 1)
            pressure = round(self.bme280.pressure)
            humidity = round(self.bme280.humidity)

        return temperature, pressure, humidity

    def measure(self):
        if self.bme280 is None:
            # BME Sensor not found so generate random data
            temperature = random.randrange(20, 25)
            pressure = random.randrange(1000, 1100)
            humidity = random.randrange(50, 70)
        else:
            # When debugging, step over, not into, as method takes a system wide/global lock
            temperature, pressure, humidity = self.read_sensor()

        return temperature, pressure, humidity
