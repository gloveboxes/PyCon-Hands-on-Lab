from flask import Flask, render_template
import random
import board
import digitalio
import busio
import time
import adafruit_bme280
from subprocess import check_output
from datetime import datetime

app = Flask(__name__)

i2c = busio.I2C(board.SCL, board.SDA)
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)


@app.route('/')
@app.route('/index')
def show_telemetry():
    now = datetime.now()
    formatted_now = now.strftime("%A, %d %B, %Y at %X")

    title = "Raspberry Pi Environment Data"
    temperature = round(bme280.temperature, 1)
    pressure = round(bme280.pressure)
    humidity = round(bme280.humidity)

    return render_template('index.html', title=title,
                           temperature=temperature, pressure=pressure,
                           humidity=humidity)
