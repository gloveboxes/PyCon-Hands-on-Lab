import paho.mqtt.client as mqtt
from datetime import datetime
import time
import iothub
import sys
import json
import ptvsd
import telemetry_client
import config
import os
import sys


ptvsd.enable_attach(address=('0.0.0.0', 3000))

try:
    connectionString = os.environ['CONNECTION_STRING']
except:
    print("Missing Connection String")
    sys.exit(1)

if connectionString == '':
    print("Missing Connection String")
    sys.exit(1)


myconfig = config.Config(connectionString)

hubAddress = myconfig.hostname
deviceId = myconfig.deviceId
sharedAccessKey = myconfig.key
sampleRateInSeconds = 4

# mysensor = sensor_bme280.Telemetry()
mysensor = telemetry_client.Telemetry()


def on_connect(client, userdata, flags, rc):
    print("Connected with result code: %s" % rc)
    client.subscribe(iot.hubTopicSubscribe)


def on_disconnect(client, userdata, rc):
    print("Disconnected with result code: %s" % rc)
    client.username_pw_set(iot.hubUser, iot.generate_sas_token(
        60 * 30))  # 60 seconds * 30 minutes


def on_message(client, userdata, msg):
    global sampleRateInSeconds
    #print("{0} - {1} ".format(msg.topic, str(msg.payload)))
    sampleRateInSeconds = msg.payload
    # Do this only if you want to send a reply message every time you receive one
    # client.publish("devices/mqtt/messages/events", "REPLY", qos=1)


def on_publish(client, userdata, mid):
    print("Message {0} sent from {1} at {2}".format(
        str(mid), deviceId, datetime.now().strftime('%Y-%m-%d %H:%M:%S')))


def publish():
    msgId = 1
    while True:
        try:
            temperature, pressure, humidity, timestamp, cpu_temperature = mysensor.measure()

            data = {
                "Geo": 'Sydney, AU',
                "Humidity": humidity,
                "Pressure": pressure,
                "Temperature": temperature,
                "CpuTemperature": cpu_temperature,
                "Epoch": timestamp,
                "Id": msgId
            }

            telemetry = json.dumps(data)
            print(telemetry)

            client.publish(iot.hubTopicPublish, telemetry)

            msgId += 1

            time.sleep(sampleRateInSeconds)

        except KeyboardInterrupt:
            print("IoTHubClient sample stopped")
            return

        except:
            print("Unexpected error")
            time.sleep(sampleRateInSeconds)


iot = iothub.IotHub(hubAddress, deviceId, sharedAccessKey)

client = mqtt.Client(deviceId, mqtt.MQTTv311)

client.on_connect = on_connect
client.on_disconnect = on_disconnect
client.on_message = on_message
client.on_publish = on_publish


client.username_pw_set(iot.hubUser, iot.generate_sas_token())
client.tls_set("/etc/ssl/certs/ca-certificates.crt")
client.connect(hubAddress, 8883)


client.loop_start()

publish()
