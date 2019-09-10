import requests
import random
import time


class Telemetry():
    def measure(self):
        retry = 0

        while retry < 2:
            try:
                response = requests.get('http://localhost:8080/telemetry')
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
                "timestamp": int(time.time()),
                "cputemperature": random.randrange(30, 90),
            }

        return telemetry.get('temperature'), telemetry.get('pressure'), telemetry.get('humidity'), telemetry.get('timestamp'), telemetry.get('cputemperature')
