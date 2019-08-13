from flask import Flask, abort
from datetime import datetime
import telemetry

myTelemetry = telemetry.Telemetry()
app = Flask(__name__)


@app.route('/')
@app.route('/index')
def show_telemetry():

    now = datetime.now()
    formatted_now = now.strftime("%A, %d %B, %Y at %X")

    html = myTelemetry.render_telemetry()

    if html is None:
        return abort(500)
    else:
        return html
