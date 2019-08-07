# Python 2.7 Sas generator https://azure.microsoft.com/en-us/documentation/articles/iot-hub-sas-tokens/#comments/

import base64
import hmac
import urllib.parse
import time


class IotHub():

    def __init__(self, hubAddress, deviceId, sharedAccessKey):
        self.sharedAccessKey = sharedAccessKey
        self.endpoint = hubAddress + '/devices/' + deviceId
        self.hubUser = hubAddress + '/' + deviceId
        self.hubTopicPublish = 'devices/' + deviceId + '/messages/events/'
        self.hubTopicSubscribe = 'devices/' + deviceId + '/messages/devicebound/#'


    # sas generator from https://github.com/bechynsky/AzureIoTDeviceClientPY/blob/master/DeviceClient.py
    def generate_sas_token(self, expiry=3600):
        ttl = int(time.time()) + expiry
        urlToSign = urllib.parse.quote(self.endpoint, safe='') 
        sign_sharedAccessKey = "%s\n%d" % (urlToSign, int(ttl))
        h = hmac.new(base64.b64decode(self.sharedAccessKey), msg = "{0}\n{1}".format(urlToSign, ttl).encode('utf-8'),digestmod = 'sha256')
        signature = urllib.parse.quote(base64.b64encode(h.digest()), safe = '')
        return "SharedAccessSignature sr={0}&sig={1}&se={2}".format(urlToSign, urllib.parse.quote(base64.b64encode(h.digest()), safe = ''), ttl)