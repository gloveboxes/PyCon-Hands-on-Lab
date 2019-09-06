# Lab 2: Raspberry Pi, Python, Azure IoT Central, and Docker Container Debugging

|Author|[Dave Glover](https://developer.microsoft.com/en-us/advocates/dave-glover?WT.mc_id=pycon-blog-dglover), Microsoft Cloud Developer Advocate |
|----|---|
|Platforms | Linux, macOS, Windows, Raspbian Buster|
|Services | [Azure IoT Central](https://docs.microsoft.com/en-us/azure/iot-central/?WT.mc_id=pycon-blog-dglover) |
|Tools| [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders?WT.mc_id=pycon-blog-dglover)|
|Hardware | [Raspberry Pi 4. 4GB](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) model required for 20 Users. Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/), Optional: Raspberry Pi [case](https://shop.pimoroni.com/products/pibow-coupe-4?variant=29210100138067), [active cooling fan](https://shop.pimoroni.com/products/fan-shim)
|**USB3 SSD Drive**| To support up to 20 users per Raspberry Pi you need a **fast** USB3 SSD Drive to run Raspbian Buster Linux on. A 120 USB3 SSD drive will be more than sufficient. These are readily available from online stores.
|Language| Python|
|Date|As of August, 2019|

Follow me on Twitter [@dglover](https://twitter.com/dglover)

## PDF Lab Guide

You may find it easier to download and follow the PDF version of the [Raspberry Pi, Python, Azure IoT Central, and Docker Container Debugging](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab2-docker-debug/README.pdf) hands-on lab guide.

## Introduction

In this hands-on lab, you will learn how to create a Python Internet of Things (IoT) application with [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover). Run the application  in a Docker Container on a Raspberry Pi, read temperature, humidity, and air pressure telemetry from a sensor, and finally debug the application running in the Docker Container.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/rpi4-pi-sense-hat.jpg)

## References

- [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover)
- [Azure IoT Central](https://azure.microsoft.com/en-au/services/iot-central?WT.mc_id=pycon-blog-dglover)
- [Installing Docker on Raspberry Pi Buster](https://dev.to/azure/azure-iot-edge-on-raspberry-pi-buster-plus-tips-for-raspberry-pi-4-22nn)
- [Understanding Docker in 12 Minutes](https://www.youtube.com/watch?v=YFl2mCHdv24&t=358s)

<!-- ## CircuitPython

[CircuitPython](www.circuitpython.org), an [Adafruit](www.adafruit.com) initiative, is built on the amazing work of Damien George and the MicroPython community. CircuitPython adds hardware support for Microcontroller development and simplifies some aspects of MicroPython. MicroPython and by extension, CircuitPython implements version 3 of the Python language reference. So, your Python 3 skills are transferrable.

CircuitPython runs on over 60 **Microcontrollers** as well as the **Raspberry Pi**. This means you build applications that access GPIO hardware on a Raspberry Pi using CircuitPython libraries.

The advantage of running CircuitPython on the Raspberry Pi is that there are powerful Python debugging tools available. If you have ever tried debugging applications on a Microcontroller, then you will appreciate it can be painfully complex and slow. You resort to print statements, toggling the state of LEDs, and worst case, using specialized hardware.

With Raspberry Pi and CircuitPython, you build and debug on the Raspberry Pi, when it is all working you transfer the app to a CircuitPython Microcontroller. You need to ensure any libraries used are copied to the Microcontroller, and pin mappings are correct. But much much simpler!

This hands-on lab uses CircuitPython libraries for GPIO, I2C, and the BME280 Temperature/Pressure/Humidity sensor. The CircuitPython libraries are installed on the Raspberry Pi with pip3.

```bash
pip3 install adafruit-blinka adafruit-circuitpython-bme280
``` -->

## Software Installation

![set up requirements](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/setup.jpg)

This hands-on lab uses Visual Studio Code. Visual Studio Code is a code editor and is one of the most popular **Open Source** projects on GitHub. It runs on Linux, macOS, and Windows.

Install:

1. [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/?WT.mc_id=pycon-blog-dglover)

    As at August 2019, **Visual Studio Code Insiders Edition** is required as it has early support for Raspberry Pi and Remote Development over SSH.

2. [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover)
3. [Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker&WT.mc_id=pycon-blog-dglover)

For information on contributing or submitting issues see the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). Visual Studio Code documentation is also Open Source, and you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

## Remote Development using SSH

The Visual Studio Code Remote - SSH extension allows you to open a remote folder on any remote machine, virtual machine, or container with a running SSH server and take full advantage of Visual Studio Code's feature set. Once connected to a server, you can interact with files and folders anywhere on the remote filesystem.

No source code needs to be on your local machine to gain these benefits since the extension runs commands and other extensions directly on the remote machine.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/architecture-ssh.png)

## Raspberry Pi Hardware

If you are attending a workshop, then you can use a shared network-connected Raspberry Pi. You will need the following information from the lab instructor.

1. The **Network IP Address** of the Raspberry Pi
2. Your assigned **login name** and **password**.

## SSH Authentication with private/public keys

![ssh login](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/ssh-login.jpg)

Setting up a public/private key pair for [SSH](https://en.wikipedia.org/wiki/Secure_Shell) authentication is a secure and fast way to authenticate from your computer to the Raspberry Pi. This is needed for this hands-on lab.

### SSH for Linux and macOS

From a Linux or macOS **Terminal Console** run the following commands:

1. Create your key. This is typically a one-time operation. **Take the default options**.

    ```bash
    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa_python_lab
    ```

2. Copy the public key to the Raspberry Pi.

    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa_python_lab <login@Raspberry IP Address>
    ```

    For example:

    ```bash
    ssh-copy-id -i ~/.ssh/id_rsa_python_lab dev99@192.168.1.200
    ```

3. Test the SSH Authentication Key

    ```bash
    ssh -i ~/.ssh/id_rsa_python_lab <login@Raspberry IP Address>
    ```

    A new SSH session will start. You should now be connected to the Raspberry Pi **without** being prompted for the password.

4. Close the SSH session. In the SSH terminal, type exit, followed by ENTER.

### SSH for Windows 10 (1809+) Users with PowerShell

1. Start PowerShell as Administrator and install OpenSSH.Client

    ```bash
        Add-WindowsCapability -Online -Name OpenSSH.Client
    ```

2. **Exit** PowerShell
3. Restart PowerShell (**NOT** as Administrator)
4. Create an SSH Key

    ```bash
    ssh-keygen -t rsa -f $env:userprofile\.ssh\id_rsa_python_lab
    ```

5. Copy SSH Key to Raspberry Pi

    ```bash
    cat $env:userprofile\.ssh\id_rsa_python_lab.pub | ssh `
    <login@Raspberry IP Address> `
    "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
    ```

6. Test the SSH Authentication Key

    ```bash
    ssh -i $env:userprofile\.ssh\id_rsa_python_lab <login@Raspberry IP Address>
    ```

    A new SSH session will start. You should now be connected to the Raspberry Pi **without** being prompted for the password.

7. Close the SSH session. In the SSH terminal, type exit, followed by ENTER.

### SSH for earlier versions of Windows

- [SSH for earlier versions of Windows](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab2-docker-debug/resources/windows-ssh.md)

### Trouble Shooting SSH Client Installation

- [Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh?WT.mc_id=pycon-blog-dglover)
- [Installing a supported SSH client](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client?WT.mc_id=pycon-blog-dglover)

## Configure Visual Studio Code Remote SSH Development

1. Start Visual Studio Code Insiders Edition

2. Press F1 to open the Command Palette, type **ssh config** and select **Remote-SSH: Open Configuration**

3. Select the user .ssh config file

    ![select the user .ssh file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-open-config-file.png)

4. Set the SSH connection configuration as follows:

    - **Host**: Set to **RaspberryPi**
    - **HostName**: The Raspberry Pi **IP Address**
    - **User**: Your **login name**
    - **IdentityFile**: Set to **~/.ssh/id_rsa_python_lab**.
    - Save these changes (Ctrl+S).

    ![configure host details](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-config-host-details.png)

5. Press **F1** to open the Command Palette, type **ssh connect** and select **Remote-SSH: Connect to Host**

6. Select the host **RaspberryPi** configuration

    ![open the ssh project](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-open-ssh-connection.png)

    It will take a moment to connect to the Raspberry Pi.

<!-- ## Install the Python Visual Studio Code Extension

![Python Extension](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-install-python.png)

Launch Visual Studio Code Quick Open (Ctrl+P), paste the following command, and press enter:

```bash
ext install ms-python.python
```

See the [Python Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python&WT.mc_id=pycon-blog-dglover) page for information about using the extension. -->

## Introduction to Docker

[Jake Wright's Docker in 12 Minutes](https://www.youtube.com/watch?v=YFl2mCHdv24&t=364s) is a great introduction to Docker.

![](resources/docker_logo.png)

## Open the Lab2 Docker Debug Project

From **Visual Studio Code**, select **File** from the main menu, then **Open Folder**. Navigate to and open the **PyLab/lab2-docker-debug** folder.

1. From VS Code: File -> Open Folder, navigate to **PyLab/lab2-docker-debug**.
2. Expand the App folder and open the app.py file.
3. If you are prompted to select a Python Interpreter then select Python 3.7

## Creating an Azure IoT Central Application

We are going to create an Azure IoT Central application, then a device, and finally a device **connection string** needed for the application that will run in the Docker container.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/azure_iot_central.png)

## Create a New IoT Central Application

1. Open the [Azure IoT Central](https://azure.microsoft.com/en-au/services/iot-central/?WT.mc_id=pycon-blog-dglover) in a new browser tab, then click **Getting started**.

2. Next, you will need to sign with your **Microsoft** Personal, or Work, or School account. If you do not have a Microsoft account, then you can create one for free using the **Create one!** link.

    ![iot central](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-login.png)

3. Create a new Azure IoT Central application, select **New Application**. This takes you to the **Create Application** page.

4. Select **Trail**, **Custom application**, name your IoT Central application and complete the sign-up information.

![Azure IoT Central Create Application page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-new-application.png)

4. Click **Create Device Templates**, then select the **Custom** template, name your template, for example, **Raspberry**. Then click Create

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-welcome-dashboard.png)

5. Edit the Template, add **Measurements** for **Temperature**, **Humidity**, and **Pressure** telemetry.

    Measurements are the data that comes from your device. You can add multiple measurements to your device template to match the capabilities of your device.

    - **Telemetry** measurements are the numerical data points that your device collects over time. They're represented as a continuous stream. An example is temperature.
    - **Event** measurements are point-in-time data that represents something of significance on the device. A severity level represents the importance of an event. An example is a fan motor error.
    - **State** measurements represent the state of the device or its components over a period of time. For example, a fan mode can be defined as having Operating and Stopped as the two possible states.
    - **Location** measurements are the longitude and latitude coordinates of the device over a period of time in. For example, a fan can be moved from one location to another.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-new-telemetry.png)

    Use the information in the following table to set up three telemetry measurements. The field name is case-sensitive.

    You **must** click **Save** after each measurement is defined.

    |Display Name| Field name     | Units  | Minimum | Maximum | Decimals |
    |------------| -------------- | ------ | ------- | ------- | -------- |
    |Humidity    | Humidity       | %      | 0       | 100     | 0        |
    |Temperature | Temperature    | degC   | -10     | 60      | 0        |
    |Pressure    | Pressure       | hPa    | 800     | 1260    | 0        |

    The following is an example of setting up the **Temperature** telemetry measurement.

    ![new measurement](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-create-new-telemetry.png)

6. Click **Device** on the sidebar menu, select the **Raspberry** template you created.

    IoT central supports real devices, such as the Raspberry Pi used for this lab, as well as simulated devices which generate random data  useful for system testing.

7. Select **Real**.

    ![create a real device](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-add-real-device.png)

    Name your **Device ID** so you can easily identify the device in the IoT Central portal, then click **Create**.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-create-new-device.png)

7. When you have created your real device click the **Connect** button in the top right-hand corner of the screen to display the device credentials.

    ![connect device](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-connect-device.png)

    **Leave this page open as you will need this connection information for the next step in the hands-on lab.**

    ![Device Connection](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-device-connection.png)

## Generate an Azure IoT Hub Connection String

1. Hold the control key down and click the following link [Connection String Generator](https://dpsgen.z8.web.core.windows.net/) to open in a new tab.

    Copy and paste the **Scope Id**, **Device Id**, and the **Primary Key** from the Azure IoT Central Device Connection panel to the Connection String Generator page and click **Get Connection String**.

    ![connection string example](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-connection-string-generator-example.png)

2. Copy the generated connection string to the clipboard as you will need it for the next step.

## Configure the Python Application

1. Switch back to Visual Studio Code. Open the **env-file** (environment file). This file contains environment variables that will be passed to the Docker container.

2. Paste the connection string you copied in the previous step into the env-file on the same line, and after  **CONNECTION_STRING=**.

    For example:

    ```text
    CONNECTION_STRING=HostName=saas-iothub-8135cd3b....
    ```

3. Save the env-file file (Ctrl+S)

<!-- 4. Ensure **Explorer** selected in the activity bar, right mouse click file named **Dockerfile** and select **Build Image**.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-docker-build.png)

5. Give your docker build image a **unique name** - eg the first part of your email address, your nickname, something memorable, followed by **:latest**. The name needs to be unique otherwise it will clash with others building Docker images on the same Raspberry Pi.

    For example **glovebox:latest**

![docker base image name](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/docker-build-name.png) -->

### Build and Run the Docker Image

Press **F5** to start debugging the Python application. The process will first build and then start the Docker Container. When the Docker Container has started the Visual Studio Code Debugger will attach to the running application.

There are two configuration files found in the .vscode folder that are responsible for running and debugging the Python application. You can find more detail the [Debugger Configuration](#debugger-configuration) appendix.

## Set a Visual Studio Debugger Breakpoint

1. From **Explorer** on the Visual Studio Code activity bar, open the **app.py** file
1. Set a breakpoint at line 66, **temperature, pressure, humidity, timestamp = mysensor.measure()** in the **publish** function.

    - You can set a breakpoint by doing any one of the following:

        - With the cursor on that line, press F9, or,
        - With the cursor on that line, select the Debug > Toggle Breakpoint menu command, or, click directly in the margin to the left of the line number (a faded red dot appears when hovering there). The breakpoint appears as a red dot in the left margin:

    ![Attached debugger](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-set-breakpoint.png)

### Debug actions

Once a debug session starts, the **Debug toolbar** will appear at the top of the editor window.

![Debug Actions](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/toolbar.png)

The debugger toolbar (shown above) will appear in Visual Studio Code. It has the following options:

1. Pause (or Continue, F5),
2. Step Over (F10)
3. Step Into (F11),
4. Step Out (Shift+F11),
5. Restart (Ctrl+Shift+F5),
6. and Stop (Shift+F5).

### Step through the Python code

1. Press **F10**, or from the Debugger Toolbar, click **Step Over** until you are past the **print(telemetry)** line of code.
2. Explore the **Variable Window** (Ctrl+Shift+Y). Try changing variable values.
3. Explore the **Debug Console**. You will see sensor telemetry and the results of sending the telemetry to Azure IoT Central.
    ![vs code debug console](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/vs-code-debug-console.png)
4. From the **Debug** Menu -> **Disable All Breakpoints**
5. Press **F5** or from the Debugger Toolbar, click **Continue** so the Python application runs and streams telemetry to **Azure IoT Central**.

## Exploring Device Telemetry in Azure IoT Central

1. Use **Device** to navigate to the **Measurements** page for the real Raspberry Pi device you added:

    ![Navigate to real device](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-select-device.png)

1. On the **Measurements** page, you can see the telemetry streaming from the Raspberry Pi device:

    ![View telemetry from real device](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/iot-central-view-telemetry.png)

## Finished

 ![Complete. Congratulations](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/resources/congratulations.jpg)

## Appendix

### Debugger Configuration

There are two files (launch.json and tasks.json) found in the .vscode folder that are responsible for the running and debugging the application.

#### Launch Configuration

Creating a launch configuration file is useful as it allows you to configure and save debugging setup details.

**launch.json**

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Attach Debugger",
            "preLaunchTask": "start-docker",
            "postDebugTask": "stop-docker",
            "type": "python",
            "request": "attach",
            "pathMappings": [
                {
                    "localRoot": "${workspaceRoot}/app",
                    "remoteRoot": "/app"
                }
            ],
            "port": "${env:LAB_PORT}",
            "host": "localhost"
        },
        {
            "name": "Stop Container",
            "preLaunchTask": "stop-docker",
            "type": "python",
            "request": "launch"
        }
    ]
}
```

#### Tasks Configuration

Tasks integrate external tools to automate build cycle.

**tasks.json**

```json
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "start-docker",
            "type": "shell",
            "command": "sh",
            "args": [
                "-c",
                "\"docker build -t $USER:latest . ;docker run -d -p $LAB_PORT:3000 -e TELEMETRY_HOST=$LAB_HOST --env-file ~/github/Lab2-docker-debug/env-file --name $USER --rm  $USER:latest; sleep 1 \""
                // -d Run container in background and print container ID,
                // -p maps the $LAB_PORT to port 3000 in the container, this port is used for debugging,
                // -e Environment Variable. The IP Address of the telemetry service.
                // --env-file reads from a file and sets Environment Variables in the Docker Container,
                // --name names the Docker Container
                // --rm removes the container when you stop it
                // Docker run reference https://docs.docker.com/engine/reference/run/
            ],
        },
        {
            "label": "stop-docker",
            "type": "shell",
            "command": "sh",
            "args": [
                "-c",
                "\"docker stop $USER\""
            ]
        }
    ]
}
```


### Azure IoT Central

#### Take a tour of the Azure IoT Central UI

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

#### Use the left navigation menu

Use the left navigation menu to access the different areas of the application. You can expand or collapse the navigation bar by selecting **<** or **>**:

![Left navigation menu](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/navigationbar-description.png)

#### Search, help, and support

The top menu appears on every page:

![Toolbar](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/toolbar.png)

- To search for device templates and devices, enter a **Search** value.
- To change the UI language or theme, choose the **Settings** icon.
- To sign out of the application, choose the **Account** icon.
- To get help and support, choose the **Help** drop-down for a list of resources. In a trial application, the support resources include access to [live chat](https://docs.microsoft.com/en-us/azure/iot-central/howto-show-hide-chat?WT.mc_id=pycon-blog-dglover).

You can choose between a light theme or a dark theme for the UI:

![Choose a theme for the UI](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/themes.png)

#### Dashboard

![Dashboard](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/homepage.png)

The dashboard is the first page you see when you sign in to your Azure IoT Central application. As a builder, you can customize the application dashboard for other users by adding tiles. To learn more, see the [Customize the Azure IoT Central operator's view](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-customize-operator?WT.mc_id=pycon-blog-dglover) tutorial. Users can also [create their own personal dashboards](https://docs.microsoft.com/en-us/azure/iot-central/howto-personalize-dashboard?WT.mc_id=pycon-blog-dglover).

#### Device explorer

![Explorer page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/explorer.png)

The explorer page shows the _devices_ in your Azure IoT Central application grouped by _device template_.

* A device template defines a type of device that can connect to your application. To learn more, see the [Define a new device type in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-define-device-type?WT.mc_id=pycon-blog-dglover).
* A device represents either a real or simulated device in your application. To learn more, see the [Add a new device to your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-add-device?WT.mc_id=pycon-blog-dglover).

#### Device sets

![Device Sets page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/devicesets.png)

The _device sets_ page shows device sets created by the builder. A device set is a collection of related devices. A builder defines a query to identify the devices that are included in a device set. You use device sets when you customize the analytics in your application. To learn more, see the [Use device sets in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-use-device-sets?WT.mc_id=pycon-blog-dglover) article.

#### Device Templates

![Device Templates page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/templates.png)

The device templates page is where a builder creates and manages the device templates in the application. To learn more, see the [Define a new device type in your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/tutorial-define-device-type?WT.mc_id=pycon-blog-dglover) tutorial.

#### Analytics

![Analytics page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/analytics.png)

The analytics page shows charts that help you understand how the devices connected to your application are behaving. An operator uses this page to monitor and investigate issues with connected devices. The builder can define the charts shown on this page. To learn more, see the [Create custom analytics for your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-use-device-sets?WT.mc_id=pycon-blog-dglover) article.

#### Jobs

![Jobs page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/jobs.png)

The jobs page allows you to perform bulk device management operations onto your devices. The builder uses this page to update device properties, settings, and commands. To learn more, see the [Run a job](https://docs.microsoft.com/en-us/azure/iot-central/howto-run-a-job?WT.mc_id=pycon-blog-dglover) article.

#### Continuous Data Export

![Continuous Data Export page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/export.png)

The continuous data export page is where an administrator defines how to export data, such as telemetry, from the application. Other services can store the exported data or use it for analysis. To learn more, see the [Export your data in Azure IoT Central](https://docs.microsoft.com/en-us/azure/iot-central/howto-export-data?WT.mc_id=pycon-blog-dglover) article.

#### Administration

![Administration page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab2-docker-debug/media/overview-iot-central-tour/administration.png)

The administration page contains links to the tools an administrator uses such as defining users and roles in the application. To learn more, see the [Administer your Azure IoT Central application](https://docs.microsoft.com/en-us/azure/iot-central/howto-administer?WT.mc_id=pycon-blog-dglover) article.
