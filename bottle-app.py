from bottle import route, run
import random
import board
import digitalio
import busio
import time
import adafruit_bme280

port = random.randrange(8000, 9000)
# app = Flask(_name_)

i2c = busio.I2C(board.SCL, board.SDA)
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

@route('/')
def hello():
    data = 'Temperature {}C, Humidity {}%, Pressure {} hPa'.format(
        round(bme280.temperature, 1), round(bme280.humidity), round(bme280.pressure))
    # return 'hello'

    return data

run(host='192.168.5.145', port=port, debug=True)