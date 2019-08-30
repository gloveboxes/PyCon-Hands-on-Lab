from flask import Flask, request, jsonify
import time
import random
from sense_hat import SenseHat


# import ptvsd
# ptvsd.enable_attach(address=('0.0.0.0', 3000))


class Telemetry():
    def __init__(self):
        self.temperature = 0
        self.humidity = 0
        self.pressure = 0
        self.timestamp = 0

        self.sense = None

        try:
            self.sense = SenseHat()
        except:
            print('Pi Sense HAT Not Found')

    def get_telemetry(self):
        try:
            delta = int(time.time()) - self.timestamp

            if self.sense is not None and delta >= 2:
                self.temperature = round(self.sense.get_temperature(), 1)                
                self.humidity = int(self.sense.get_humidity())
                self.pressure = int(self.sense.get_pressure())
                self.timestamp = int(time.time())

            elif self.sense is None:
                # BME Sensor not found so generate random data
                self.temperature = random.randrange(25, 35)
                self.pressure = random.randrange(900, 1300)
                self.humidity = random.randrange(20, 80)
                self.timestamp = int(time.time())

            telemetry = {
                "temperature": self.temperature,
                "humidity": self.humidity,
                "pressure": self.pressure,
                "timestamp": self.timestamp
            }

            return jsonify(telemetry)

        except Exception as e:
            print('EXCEPTION:', str(e))
            return 'Error processing image', 500


app = Flask(__name__)
t = Telemetry()


@app.route('/telemetry', methods=['GET'])
def telemetry():
    return t.get_telemetry()


if __name__ == '__main__':
    # Run the server
    app.run(host='0.0.0.0', port=8080)
