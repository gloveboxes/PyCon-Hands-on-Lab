import sys
import board
import digitalio
import busio
import time
import adafruit_bme280


class Sensor():

    def __init__(self, geoLocation='Sydney, au'):
        self.geoLocation = geoLocation
        self.id = 0
        self.i2c = busio.I2C(board.SCL, board.SDA)
        self.bme280 = adafruit_bme280.Adafruit_BME280_I2C(
            self.i2c, address=0x76)

    def measure(self):
        msg_txt = "{\"Geo\":\"%s\",\"Humidity\":%d,\"hPa\":%d,\"Celsius\": %.2f,\"Light\":%d,\"Id\":%d}"

        temperature = round(self.bme280.temperature, 1)
        pressure = round(self.bme280.pressure)
        humidity = round(self.bme280.humidity)
        self.id += 1

        telemetry = msg_txt % (self.geoLocation, humidity,
                               pressure,  temperature, 0, self.id)

        return telemetry
