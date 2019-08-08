from flask import Flask, render_template
import random
import board
import digitalio
import busio
import time
import adafruit_bme280
from subprocess import check_output

port = random.randrange(8000, 9000)
host = check_output(["hostname", "-I"]).decode().split(' ')[0] # get the Host IP Address

app = Flask(__name__)

i2c = busio.I2C(board.SCL, board.SDA)
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

# https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-ii-templates


@app.route('/')
@app.route('/index')
def telemetry():

    title = "Raspberry Pi Environment Data"
    temperature = round(bme280.temperature, 1)
    pressure = round(bme280.pressure)
    humidity = round(bme280.humidity)

    return render_template('index.html', title=title,
                           temperature=temperature, pressure=pressure,
                           humidity=humidity)


if __name__ == '__main__':
    # Run the server
    app.run(host='<Raspberry PI IP Address>', port=port)
