# Python Flash Lab 1

```python

from flask import Flask, render_template
import random
import board
import digitalio
import busio
import time
import adafruit_bme280

port = random.randrange(8000, 9000)
app = Flask(__name__)

i2c = busio.I2C(board.SCL, board.SDA)
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

# https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-ii-templates

@app.route('/')
@app.route('/index')
def hello_world():
    return render_template('index.html', title='Raspberry Pi Environment Data',
                           temperature=round(bme280.temperature, 1), pressure=round(bme280.pressure),
                           humidity=round(bme280.humidity))


if __name__ == '__main__':
    # Run the server
    app.run(host='192.168.0.198', port=port)


```
