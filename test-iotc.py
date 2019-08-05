# import board
# import digitalio
# import busio
# import time
# import adafruit_bme280
import iotc
from iotc import IOTConnectType, IOTLogLevel
import ptvsd
from random import randint

deviceId = "dev01"
scopeId = "scope id"
deviceKey = "key"


# i2c = busio.I2C(board.SCL, board.SDA)
# bme280 = adafruit_bme280.Adafruit_BME280_I2C(i2c, address=0x76)

iotc = iotc.Device(scopeId, deviceKey, deviceId,
                   IOTConnectType.IOTC_CONNECT_SYMM_KEY)
iotc.setLogLevel(IOTLogLevel.IOTC_LOGGING_API_ONLY)

gCanSend = False
gCounter = 0


def onconnect(info):
    global gCanSend
    print("- [onconnect] => status:" + str(info.getStatusCode()))
    if info.getStatusCode() == 0:
        if iotc.isConnected():
            gCanSend = True


def onmessagesent(info):
    print("\t- [onmessagesent] => " + str(info.getPayload()))


def oncommand(info):
    print("- [oncommand] => " + info.getTag() +
          " => " + str(info.getPayload()))


def onsettingsupdated(info):
    print("- [onsettingsupdated] => " +
          info.getTag() + " => " + info.getPayload())


iotc.on("ConnectionStatus", onconnect)
iotc.on("MessageSent", onmessagesent)
iotc.on("Command", oncommand)
iotc.on("SettingsUpdated", onsettingsupdated)

iotc.connect()

while iotc.isConnected():
    iotc.doNext()  # do the async work needed to be done for MQTT
    if gCanSend == True:
        if gCounter % 20 == 0:
            gCounter = 0
            print("Sending telemetry..")
            iotc.sendTelemetry("{ \
            \"Celsius\": " + str(randint(20, 45)) + ", \
            \"accelerometerX\": " + str(randint(2, 15)) + ", \
            \"accelerometerY\": " + str(randint(3, 9)) + ", \
            \"accelerometerZ\": " + str(randint(1, 4)) + "}")

        gCounter += 1
