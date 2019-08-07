# Lab 2: Raspberry Pi, Python, IoT Central, and Docker Container Debugging

In this hands-on lab you will learn how to create an Internet of Things (IoT) Python application with [Visual Studio Code](https://code.visualstudio.com/), run it in a Docker Container on a Raspberry Pi, and attach and debug the code running in the container.

## Lab Information

You need the following information for the Hands-on Lab.

1. The IP Address of the Raspberry Pi
1. Your login name. The default password is **raspberry**.

There are three main sections in this hands-on lab.

1. Installing the required software
2. Configuring SSH security
3. Connecting Visual Studio Code to the Raspberry Pi over SSH
4. [Creating an Azure IoT Central application](#creating-an-azure-iot-central-application)
5. [Creating an IoT Connection String](#tbd)
6. Configure, Build, and Run the Docker Container on the Raspberry Pi.
7. Attach and debug the application running in the Docker Container on the Raspberry Pi.

## Prerequisite Software Installation

![](resources/setup.jpg)

As at August 2019 Visual Studio Code **Insiders Edition** is required as it has early support for Remote Development over SSH.

Visual Studio Code is a source code editor and is an one of the most popular Open Source projects on GitHub. It is supported on Linux, macOS, and Windows.

You can for more information on contributing or submitting issues from the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). The documentation is also Open Source, you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

1. Install [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/)
1. Install the [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)
1. Install the [Docker VS Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)

## SSH Authentication with private/public keys

![ssh login](resources/ssh-login.jpg)

Setting up public/private keys for SSH login and authentication is very handy (and secure), and required for this hands-on lab.

The following creates a new SSH key, copies the public key to the Raspberry Pi. Take the default options.

### From Windows

1. Use the built-in Windows 10 (1809+) OpenSSH client. First install the OpenSSH Client for Windows (one time only operation).

    From **PowerShell as Administrator**.

```bash
Add-WindowsCapability -Online -Name OpenSSH.Client
```

2. From PowerShell, create a key pair.

```bash
ssh-keygen -t rsa
```

3. From PowerShell, copy the public key to your Raspberry Pi

```bash
cat ~/.ssh/id_rsa.pub | ssh pi@raspberrypi.local "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
```

### From Linux, macOS, and the Windows Subsystem for Linux

1. Create your key. Typically a one time operation.

```bash
ssh-keygen -t rsa
```

2. Copy the public key to your Raspberry Pi. From Linux and macOS.

```bash
ssh-copy-id pi@raspberrypi.local
```

## Configure Visual Studio Code Remote SSH Development

We need to tell Visual Studio Code the IP Address and user name we will be using to connect to the Raspberry Pi.

1. Start Visual Studio Code Insiders Edition

2. Click the **Open Remote Windows** button. You will find this button on the bottom left hand corner of the Visual Studio Code window.

    ![select the user config file](resources/vs-code-open-remote-window.png)

3. Select **Open Configuration File** and configure the SSH connection.

    ![open configuration file](resources/vs-code-open-configuration.png)

4. Select the user .ssh config file

    ![select the user .ssh file](resources/vs-code-open-config-file.png)

5. Configure the ssh connection file. You will need the IP Address of the Raspberry Pi and the user name assigned to you for the hands-on lab. Make the changes then save the changes.

    ![configure host details](resources/vs-code-config-host-details.png)

6. Select Remote SSH: Connect to Host

    ![connect to host](resources/vs-code-connect-host.png)

7. Select the host **RaspberryPi** configuration

    ![open the ssh project](resources/vs-code-open-ssh-connection.png)

    It will take a moment to connect to the Raspberry Pi.

## Open the Lab2 Docker Debug Project

1. From **Visual Studio Code**, select **File** from the main menu, the **Open Folder**. Navigate and open the **github/lab2-docker-debug** folder.
2. From VS Code: File -> Open Folder, navigate to github/lab2-docker-debug
3. Expand the App folder, and open the app.py file.

Next we are going to create an Azure IoT Central application, then create a device, and finally create an Azure IoT Hub device connection string required for the application that will run in the Docker Container.

## Creating an Azure IoT Central application

![](media/azure_iot_central.png)

As a _builder_, you use the Azure IoT Central UI to define your Microsoft Azure IoT Central application. This quickstart shows you how to create an Azure IoT Central application that contains a sample _device template_ and simulated _devices_.

Navigate to the Azure IoT Central [Application Manager](https://aka.ms/iotcentral) page. You will need to sign in with a Microsoft personal or work or school account.

To start creating a new Azure IoT Central application, select **New Application**. This takes you to the **Create Application** page.

![Azure IoT Central Create Application page](media/quick-deploy-iot-central/iotcentralcreate.png)

To create a new Azure IoT Central application:

1. Choose the **Trail** payment plan:
   - **Trial** applications are free for 7 days before they expire. They can be converted to Pay-As-You-Go at any time before they expire.
   - **Pay-As-You-Go** applications are charged per device, with the first 5 devices free.

     Learn more about pricing on the [Azure IoT Central pricing page](https://azure.microsoft.com/pricing/details/iot-central?WT.mc_id=github-blog-dglover).

1. Choose a friendly application name, such as **Contoso IoT**. Azure IoT Central generates a unique URL prefix for you. You can change this URL prefix to something more memorable.

1. Choose the **Sample Devkits** application template.

1. Select **Create**.

## Next steps

# Take a tour of the Azure IoT Central UI

This article introduces you to the Microsoft Azure IoT Central UI. You can use the UI to create, manage, and use an Azure IoT Central solution and its connected devices.

As a _builder_, you use the Azure IoT Central UI to define your Azure IoT Central solution. You can use the UI to:

- Define the types of device that connect to your solution.
- Configure the rules and actions for your devices.
- Customize the UI for an _operator_ who uses your solution.

As an _operator_, you use the Azure IoT Central UI to manage your Azure IoT Central solution. You can use the UI to:

- Monitor your devices.
- Configure your devices.
- Troubleshoot and remediate issues with your devices.
- Provision new devices.


## Use the left navigation menu

Use the left navigation menu to access the different areas of the application. You can expand or collapse the navigation bar by selecting **<** or **>**:

![Left navigation menu](media/overview-iot-central-tour/navigationbar-description.png)

## Search, help, and support

The top menu appears on every page:

![Toolbar](media/overview-iot-central-tour/toolbar.png)

- To search for device templates and devices, enter a **Search** value.
- To change the UI language or theme, choose the **Settings** icon.
- To sign out of the application, choose the **Account** icon.
- To get help and support, choose the **Help** drop-down for a list of resources. In a trial application, the support resources include access to [live chat](https://docs.microsoft.com/en-us/azure/iot-central/howto-show-hide-chat?WT.mc_id=github-blog-dglover).

You can choose between a light theme or a dark theme for the UI:

![Choose a theme for the UI](media/overview-iot-central-tour/themes.png)

## Dashboard

![Dashboard](media/overview-iot-central-tour/homepage.png)

The dashboard is the first page you see when you sign in to your Azure IoT Central application. As a builder, you can customize the application dashboard for other users by adding tiles. To learn more, see the [Customize the Azure IoT Central operator's view](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-customize-operator?WT.mc_id=github-blog-dglover) tutorial. Users can also [create their own personal dashboards](https://docs.microsoft.com/en-us/azure/iot-central/howto-personalize-dashboard?WT.mc_id=github-blog-dglover).

## Device explorer

![Explorer page](media/overview-iot-central-tour/explorer.png)

The explorer page shows the _devices_ in your Azure IoT Central application grouped by _device template_.

* A device template defines a type of device that can connect to your application. To learn more, see the [Define a new device type in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-define-device-type?WT.mc_id=github-blog-dglover).
* A device represents either a real or simulated device in your application. To learn more, see the [Add a new device to your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-add-device?WT.mc_id=github-blog-dglover).

## Device sets

![Device Sets page](media/overview-iot-central-tour/devicesets.png)

The _device sets_ page shows device sets created by the builder. A device set is a collection of related devices. A builder defines a query to identify the devices that are included in a device set. You use device sets when you customize the analytics in your application. To learn more, see the [Use device sets in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-use-device-sets?WT.mc_id=github-blog-dglover) article.

## Device Templates

![Device Templates page](media/overview-iot-central-tour/templates.png)

The device templates page is where a builder creates and manages the device templates in the application. To learn more, see the [Define a new device type in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-define-device-type?WT.mc_id=github-blog-dglover) tutorial.

## Next steps

# Connecting a Raspberry Pi to your Azure IoT Central application

This article describes how, as a device developer, to connect a Raspberry Pi to your Microsoft Azure IoT Central application using the Python programming language.

## Before you begin

To complete the steps in this article, you need the following components:

- An Azure IoT Central application created from the **Sample Devkits** application template. For more information, see the [create an application quickstart](quick-deploy-iot-central.md).
- A Raspberry Pi device running the Raspbian operating system. The Raspberry Pi must be able to connect to the internet. For more information, see [Setting up your Raspberry Pi](https://projects.raspberrypi.org/en/projects/raspberry-pi-setting-up/3).

## Sample Devkits application

An application created from the **Sample Devkits** application template includes a **Raspberry Pi** device template with the following characteristics:

- Telemetry, which includes the following measurements the device will collect:
  - Humidity
  - Temperature
  - Pressure
  - Magnetometer (X, Y, Z)
  - Accelerometer (X, Y, Z)
  - Gyroscope (X, Y, Z)
- Settings
  - Voltage
  - Current
  - Fan Speed
  - IR toggle.
- Properties
  - Die number device property
  - Location cloud property

For the full details of the configuration of the device template, see the [Raspberry Pi Device template details](howto-connect-raspberry-pi-python.md#raspberry-pi-device-template-details).

## Add a real device

In your Azure IoT Central application, add a real device from the **Raspberry Pi** device template. For more information, see [Add a real device to your Azure IoT Central application](tutorial-add-device.md).

## Raspberry Pi Device template details

An application created from the **Sample Devkits** application template includes a **Raspberry Pi** device template with the following characteristics:

### Telemetry measurements

| Field name     | Units  | Minimum | Maximum | Decimal places |
| -------------- | ------ | ------- | ------- | -------------- |
| humidity       | %      | 0       | 100     | 0              |
| temp           | °C     | -40     | 120     | 0              |
| pressure       | hPa    | 260     | 1260    | 0              |

## Add a real device

### Get your device connection details

In your Azure IoT Central application, add a real device from the **Raspberry Pi** device template and make a note of the device connection details: **Scope ID, Device ID, and Primary key**:

1. Add a **real device** from Device Explorer, select **+New > Real** to add a real device.

    * Enter a lowercase **Device ID**, or use the suggested **Device ID**.
    * Enter a **Device Name**, or use the suggested name

    ![Add Device](media/howto-connect-devkit/add-device.png)

1. To get the device connection details, **Scope ID**, **Device ID**, and **Primary key**, select **Connect** on the device page.

    ![iot central connect](resources/iot-central-connect.png)

    ![Connection details](media/howto-connect-devkit/device-connect.png)

## Generate an Azure IoT Hub Compatible Connection String

Hold the control key down and click the following link [Connection String Generator](https://dpsgen.z8.web.core.windows.net/) to open in a new tab.

Copy and paste the "Scope Id", "Device Id", and the "Primary Key" from the Azure IoT Central Device Connection panel to the Connection String Generator page and click "Get Connection String".

![connection string example](resources/iot-central-connection-string-generator-example.png)

Copy the generated connection string to the clipboard as you will need it for the next step.

## Open Docker Debug Solution


1. Update the connection string with the Azure IoT Hub Connection String

    The connection string line will look similar to this.

    ```python
    connectionString = 'HostName=saas-iothub-816767b-f33a-7878-a44a-7ca898989b6.azure-devices.net;DeviceId=dev01;SharedAccessKey=OAlZmsssIGrgjzPaxxxxxxxyI5Yi1Am9w/db4='
    ```

    ![iot hub connection string](resources/iot-hub-connection-string.png)

1. Right mouse click the Dockerfile and select **Build Image**
1. Give your docker build image a **unique name** - eg the first part of your email address, your nick name, something memorable. The name needs to be unique otherwise it will clash with others users.

    ![docker base image name](resources/docker-build-name.png)

4. When your Docker image has built then start the docker container from the VS Code terminal window.

    ![docker run](resources/docker-run.png)

5. Click [Random Number Generator](https://www.random.org/integers/?num=100&min=3000&max=5000&col=5&base=10&format=html&rnd=new) and pick a number (and make a note of it). This will become your IP Port number that you will use to attach the Visual Studio Code debugger.

```bash
docker run -it -p YOUR_RANDOM_PORT_NUMBER:3003 --device /dev/i2c-0 --device /dev/i2c-1 --rm --privileged YOUR_IMAGE_NAME:latest
```

## Configure the Visual Studio Debugger

1. Expand the .vscode folder, open the launch.json file
2. Change the current port (3005) to the randomly generated port number you used when you started the Docker container

![vs code attach debugger](resources/vs-code-attach-debugger.png)You can view the telemetry measurements and reported property values, and configure settings in Azure IoT Central:

## Attach the Debugger to the Docker Container

![Attached debugger](resources/vs-code-start-debugger.png)

## Debugger Controls

Debugger Controls allow for Starting, Pausing, Stepping in to, Stepping out off, restarting code, and finally disconnecting the debugger.

![vs code debugger controls](resources/vs-code-debug-controls.png)

## Exploring Device Telemetry in Azure IoT Central

1. Use **Device Explorer** to navigate to the **Measurements** page for the real Raspberry Pi device you added:

    ![Navigate to real device](media/howto-connect-devkit/realdevicenew.png)

1. On the **Measurements** page, you can see the telemetry coming from the Raspberry Pi device:

    ![View telemetry from real device](media/howto-connect-devkit/devicetelemetrynew.png)

## Finished

 ![Complete. Congratulations](resources/congratulations.jpg)

## Appendix

### Azure IoT Central

#### Analytics

![Analytics page](media/overview-iot-central-tour/analytics.png)

The analytics page shows charts that help you understand how the devices connected to your application are behaving. An operator uses this page to monitor and investigate issues with connected devices. The builder can define the charts shown on this page. To learn more, see the [Create custom analytics for your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-use-device-sets?WT.mc_id=github-blog-dglover) article.

#### Jobs

![Jobs page](media/overview-iot-central-tour/jobs.png)

The jobs page allows you to perform bulk device management operations onto your devices. The builder uses this page to update device properties, settings, and commands. To learn more, see the [Run a job](https://docs.microsoft.com/en-us/azure/iot-central/howto-run-a-job?WT.mc_id=github-blog-dglover) article.

#### Continuous Data Export

![Continuous Data Export page](media/overview-iot-central-tour/export.png)

The continuous data export page is where an administrator defines how to export data, such as telemetry, from the application. Other services can store the exported data or use it for analysis. To learn more, see the [Export your data in Azure IoT Central](https://docs.microsoft.com/en-us/azure/iot-central/howto-export-data?WT.mc_id=github-blog-dglover) article.

#### Administration

![Administration page](media/overview-iot-central-tour/administration.png)

The administration page contains links to the tools an administrator uses such as defining users and roles in the application. To learn more, see the [Administer your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-administer?WT.mc_id=github-blog-dglover) article.
