import requests
import random
import time
import os
import sys


class Telemetry():
    def __init__(self):
        try:
            host = os.environ['TELEMETRY_HOST']
        except:
            print("Missing Telemetry Host IP Address")
            sys.exit(1)

        self.telemetry_host = 'http://{}:8080/telemetry'.format(host)

    def measure(self):
        retry = 0

        while retry < 2:
            try:
                response = requests.get(self.telemetry_host)
                telemetry = response.json()
                break
            except:
                retry += 1

        else:
            print('Error connecting to telemetry services')
            telemetry = {
                "temperature": random.randrange(20, 25),
                "humidity": random.randrange(50, 90),
                "pressure": random.randrange(905, 1300),
                "timestamp": int(time.time())
            }

        return telemetry.get('temperature'), telemetry.get('pressure'), telemetry.get('humidity'), telemetry.get('timestamp')
