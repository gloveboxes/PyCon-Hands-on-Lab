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
        self.cputemperature = 0

        self.sense = None

        self.colourCount = 0
        self.colourPalette = [(255, 0, 0), (0, 255, 0), (0, 0, 255)]
        self.colourLength = len(self.colourPalette)

        try:
            self.sense = SenseHat()
            # fix for pressure which doesn't seem to work first time
            warmup = 0
            while warmup < 2:
                time.sleep(0.5)
                self.sense.get_temperature_from_pressure()
                self.sense.get_humidity()
                self.sense.get_pressure()
                warmup += 1

        except:
            print('Pi Sense HAT Not Found')

    def get_cpu_temperature(self):
        temp = 0.0
        with open('/sys/class/thermal/thermal_zone0/temp') as temperaturefile:
            try:
                temp = float(temperaturefile.read()) / 1000
            except:
                print('Problem reading CPU Temperature')
        return temp

    def get_telemetry(self):
        try:
            self.sense.clear(
                self.colourPalette[self.colourCount % self.colourLength])
            self.colourCount += 1

            delta = int(time.time()) - self.timestamp

            if self.sense is not None and delta >= 5:
                self.temperature = round(
                    self.sense.get_temperature_from_pressure(), 1)
                self.humidity = int(self.sense.get_humidity())
                self.pressure = int(self.sense.get_pressure())
                self.timestamp = int(time.time())
                self.cpu_temperature = round(self.get_cpu_temperature, 1)

            elif self.sense is None:
                # BME Sensor not found so generate random data
                self.temperature = random.randrange(25, 35)
                self.pressure = random.randrange(900, 1300)
                self.humidity = random.randrange(20, 80)
                self.timestamp = int(time.time())
                self.cpu_temperature = round(self.get_cpu_temperature, 1)

            telemetry = {
                "temperature": self.temperature,
                "humidity": self.humidity,
                "pressure": self.pressure,
                "timestamp": self.timestamp,
                "cputemperature": self.cpu_temperature
            }
            time.sleep(0.05)
            data = jsonify(telemetry)
            return data

        except Exception as e:
            print('EXCEPTION:', str(e))
            return 'Error processing image', 500
        finally:
            self.sense.clear()


app = Flask(__name__)
t = Telemetry()


@app.route('/telemetry', methods=['GET'])
def telemetry():
    return t.get_telemetry()


if __name__ == '__main__':
    # Run the server
    app.run(host='0.0.0.0', port=8080)
