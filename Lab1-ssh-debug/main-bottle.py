from bottle import route, run
from datetime import datetime, date
import random
import board
import digitalio
import busio
import time
import adafruit_bme280

port = random.randrange(8000, 9000)

i2c = busio.I2C(board.SCL, board.SDA)
bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

now = datetime.now()
current_time = now.strftime("%H:%M:%S")

# Note, deliberately not using templates to reduce memory footprint
@route('/')
def telemetry():
    title = "Environment Data"
    temperature = round(bme280.temperature, 1)
    pressure = round(bme280.pressure)
    humidity = round(bme280.humidity)

    html_text = f'''
<html>
<head>
    <title>{ title }</title>
</head>
<body>
    <h1>{ title }</h1>
    <table style="width:30%">
        <tr>
            <th align="left">Telemetry</th>
            <th align="left">Value</th>
        </tr>
        <tr>
            <td>Temperature</td>
            <td>{ temperature } C</td>
        </tr>
        <tr>
            <td>Humidity</td>
            <td>{ humidity } %</td>
        </tr>
        <tr>
            <td>Pressure</td>
            <td>{ pressure } hPa</td>
        </tr>
    </table>
</body>

</html>
'''

    return html_text


run(host='<Raspberry PI IP Address>', port=port, debug=True)
