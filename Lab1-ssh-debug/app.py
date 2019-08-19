from flask import Flask, abort, render_template
from datetime import datetime
import sensor_bme280
import time

myTelemetry = sensor_bme280.Telemetry()
app = Flask(__name__)


@app.route('/')
@app.route('/index')
def show_telemetry():

    now = datetime.now()
    formatted_now = now.strftime("%A, %d %B, %Y at %X")

    title = "Raspberry Pi Environment Data"

    temperature, pressure, humidity, epoch = myTelemetry.measure()

    sensor_updated = time.strftime(
        "%A, %d %B, %Y at %X", time.localtime(epoch))

    if -10 <= temperature <= 60 and 800 <= pressure <= 1500 and 0 <= humidity <= 100:
        return render_template('index.html', title=title,
                               temperature=temperature, pressure=pressure,
                               humidity=humidity)
    else:
        return abort(500)
