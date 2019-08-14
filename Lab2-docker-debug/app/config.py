# HostName=saas-iothub-8135cd3b-f33a-4002-a44a-7ca5961b00b6.azure-devices.net;DeviceId=dev01;SharedAccessKey=OAlZmyVAvIGrgjzPaZUMEZASspNFWyI5Yi1Am9w/db4=;



class Config():
    def __init__(self, connectionString):
        # self.host = None
        # self.deviceId = None
        # self.key = None
        # self.connectionString = connectionString
        self.config = dict(map(lambda x: x.split('=', 1), connectionString.split(';',2)))

    @property
    def hostname(self):
        return self.config['HostName']

    @property
    def deviceId(self):
        return self.config['DeviceId']

    @property
    def key(self):
        return self.config['SharedAccessKey']



