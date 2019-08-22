from flask import Flask, request, jsonify
import time
import random

platformSupported = True
try:
    import board
    import digitalio
    import busio
    import adafruit_bme280
except:
    platformSupported = False
    print('platform not supported')

# import ptvsd
# ptvsd.enable_attach(address=('0.0.0.0', 3000))


class Telemetry():
    def __init__(self):
        self.temperature = 0
        self.humidity = 0
        self.pressure = 0
        self.timestamp = 0

        self.bme280 = None

        if platformSupported:
            retry = 0
            while retry < 5:
                try:
                    self.i2c = busio.I2C(board.SCL, board.SDA)

                    self.bme280 = adafruit_bme280.Adafruit_BME280_I2C(
                        self.i2c, address=0x76)
                    break
                except:
                    retry += 1
                    time.sleep(0.5)
                    print('retrying sensor connect')
            else:
                print('Could not connect to sensor - check connection')

    def get_telemetry(self):
        try:
            delta = int(time.time()) - self.timestamp

            if self.bme280 is not None and delta >= 10:
                self.temperature = round(self.bme280.temperature, 1)
                self.pressure = round(self.bme280.pressure)
                self.humidity = round(self.bme280.humidity)
                self.timestamp = int(time.time())

            elif self.bme280 is None:
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
