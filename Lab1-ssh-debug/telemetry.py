from flask import render_template
from datetime import datetime
import board
import digitalio
import busio
import adafruit_bme280


class Telemetry():
    def __init__(self):
        self.i2c = busio.I2C(board.SCL, board.SDA)
        self. bme280 = adafruit_bme280.Adafruit_BME280_I2C(
            self.i2c, address=0x76)

    def render_telemetry(self):
        now = datetime.now()
        formatted_now = now.strftime("%A, %d %B, %Y at %X")

        title = "Raspberry Pi Environment Data"
        temperature = round(self.bme280.temperature, 1)
        pressure = round(self.bme280.pressure)
        humidity = round(self.bme280.humidity)

        html = render_template('index.html', title=title,
                               temperature=temperature, pressure=pressure,
                               humidity=humidity)

        return html
