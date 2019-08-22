# Lab 1: Debugging a Raspberry Pi Internet of Things Flask Application

|Author|[Dave Glover](https://developer.microsoft.com/en-us/advocates/dave-glover?WT.mc_id=pycon-blog-dglover), Microsoft Cloud Developer Advocate |
|----|---|
|Platforms | Linux, macOS, Windows, Raspbian Buster|
|Tools| [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders?WT.mc_id=pycon-blog-dglover)|
|Language| Python|
|Date|As of August, 2019|

Follow me on Twitter [@dglover](https://twitter.com/dglover)

## PDF Lab Guide

You may find it easier to download and follow the PDF version of the [Debugging Raspberry Pi Internet of Things Flask App](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab1-ssh-debug/README.pdf) hands-on lab guide.

## Introduction

In this hands-on lab, you will learn how to create and debug a Python web application on a Raspberry Pi with [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover) and the [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover) extension. The web app will read the temperature, humidity, and air pressure telemetry from a BME280 sensor connected to the Raspberry Pi.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/rpi-bme280.jpg)

## Remote Development using SSH

The Visual Studio Code Remote - SSH extension allows you to open a remote folder on any remote machine, virtual machine, or container with a running SSH server and take full advantage of Visual Studio Code's feature set. Once connected to a server, you can interact with files and folders anywhere on the remote filesystem.

No source code needs to be on your local machine to gain these benefits since the extension runs commands and other extensions directly on the remote machine.

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/architecture-ssh.png)

## CircuitPython

![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/circuitpython-logo.png)

[CircuitPython](www.circuitpython.org), an [Adafruit](www.adafruit.com) initiative, is built on the amazing work of Damien George and the MicroPython community. CircuitPython adds hardware support for Microcontroller development and simplifies some aspects of MicroPython. MicroPython and by extension, CircuitPython implements version 3 of the Python language reference. So, your Python 3 skills are transferrable.

CircuitPython runs on over 60 **Microcontrollers** as well as the **Raspberry Pi**. This means you build applications that access GPIO hardware on a Raspberry Pi using CircuitPython libraries.

The advantage of running CircuitPython on the Raspberry Pi is that there are powerful Python debugging tools available. If you have ever tried debugging applications on a Microcontroller, then you will appreciate it can be painfully complex and slow. You resort to print statements, toggling the state of LEDs, and worst case, using specialized hardware.

With Raspberry Pi and CircuitPython, you build and debug on the Raspberry Pi, when it is all working you transfer the app to a CircuitPython Microcontroller. You need to ensure any libraries used are copied to the Microcontroller, and pin mappings are correct. But much much simpler!

This hands-on lab uses CircuitPython libraries for GPIO, I2C, and the BME280 Temperature/Pressure/Humidity sensor. The CircuitPython libraries are installed on the Raspberry Pi with pip3.

```bash
pip3 install adafruit-blinka adafruit-circuitpython-bme280
```

## Software Installation

![set up requirements](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/setup.jpg)

This hands-on lab uses Visual Studio Code. Visual Studio Code is a code editor and is one of the most popular **Open Source** projects on GitHub. It runs on Linux, macOS, and Windows.

1. [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/?WT.mc_id=pycon-blog-dglover)

    As at August 2019, **Visual Studio Code Insiders Edition** is required as it has early support for Raspberry Pi and Remote Development over SSH.

2. [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover)

For information on contributing or submitting issues see the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). Visual Studio Code documentation is also Open Source, and you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

## Raspberry Pi Hardware

If you are attending a workshop, then you can use a shared network-connected Raspberry Pi. You can also use your own network-connected Raspberry Pi for this hands-on lab.

You will need the following information from the lab instructor.

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

[SSH for earlier versions of Windows](windows-ssh.md)

### Trouble Shooting SSH Client Installation

- [Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh?WT.mc_id=pycon-blog-dglover)
- [Installing a supported SSH client](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client?WT.mc_id=pycon-blog-dglover)

## Configure Visual Studio Code Remote SSH Development

We need to tell Visual Studio Code the IP Address and login name we will be using to connect to the Raspberry Pi.

1. Start Visual Studio Code Insiders Edition

2. Click the **Open Remote Windows** button. You will find this button in the bottom left-hand corner of the Visual Studio Code window.

    ![select the user config file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-remote-window.png)

3. Select **Open Configuration File**

    ![open configuration file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-configuration.png)

4. Select the user .ssh config file

    ![select the user .ssh file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-config-file.png)

5. Set the SSH connection configuration. You will need the Raspberry Pi **IP Address**, the Raspberry Pi **login name**, and finally set the **IdentityFile** field to **~/.ssh/id_rsa_python_lab**. Save these changes (Ctrl+S).

    ![configure host details](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-config-host-details.png)

6. Click the Open Remote Windows button (bottom left) then select **Remote SSH: Connect to Host**

    ![connect to host](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-connect-host.png)

7. Select the host **RaspberryPi** configuration

    ![open the ssh project](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-ssh-connection.png)

    It will take a moment to connect to the Raspberry Pi.

## Install the Python Visual Studio Code Extension

![Python Extension](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-install-python.png)

Launch Visual Studio Code Quick Open (Ctrl+P), paste the following command, and press enter:

```bash
ext install ms-python.python
```

See the [Python Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python&WT.mc_id=pycon-blog-dglover) page for information about using the extension.

## Open the Lab 1 SSH Debug Project

From **Visual Studio Code**, select **File** from the main menu, then **Open Folder**. Navigate to and open the **github/Lab1-ssh-debug** folder.

1. From Visual Studio Code: File -> Open Folder
2. Navigate to **github/Lab1-ssh-debug** directory
3. Open the **app.py** file and review the contents
4. Set a breakpoint at the first line of code in the **show_telemetry** function (**now = datetime.now()**) by doing any one of the following:

    - With the cursor on that line, press F9, or,
    - With the cursor on that line, select the Debug > Toggle Breakpoint menu command, or, click directly in the margin to the left of the line number (a faded red dot appears when hovering there). The breakpoint appears as a red dot in the left margin:

    ![Start the flask web application](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-flask-app.png)

5. Review the **debug** options.
    1. Switch to Debug view in Visual Studio Code (using the left-side activity bar).

        ![open launch json file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-launch-json.png)

    2. Click the **Settings** button which will open the **launch.json** file.
    3. The **launch.json** file defines how the Flask app will be started, and what [Flask Command Line](https://flask.palletsprojects.com/en/1.0.x/cli/) parameters will be passed on at startup.

        There are two environment variables used in the launch.json file. These are **LAB_HOST** (which is the IP Address of the Raspberry Pi), and **LAB_PORT** (a random TCP/IP Port number between 5000 and 8000). These environment variables are set by the .bashrc script which runs when you connect to the Raspberry Pi with Visual Studio Remote SSH.

6. Press F5 (or click the Run icon) to launch the **Python: Flask** debug configuration. This will start the Web Application on the Raspberry Pi in debug mode.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-launch-debugger.png)

7. Ctrl+click the Flask Web link in the Visual Studio Terminal Window. This will launch your desktop Web Browser.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-start-web-browser.png)

8. Next switch back to Visual Studio Code. The code execution has stopped at the breakpoint you set.

## Debug actions

Once a debug session starts, the **Debug toolbar** will appear at the top of the editor window.

![Debug Actions](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/toolbar.png)

A debugging toolbar (shown above) will appear in Visual Studio Code. It has the following options:

1. Pause (or Continue, F5),
2. Step Over (F10)
3. Step Into (F11),
4. Step Out (Shift+F11),
5. Restart (Ctrl+Shift+F5),
6. and Stop (Shift+F5).

## Using the Debugger

Next, we are going to **Step Into** (F11) the code using the debugging toolbox. Observe the debugger steps into the **Telemetry** class and calls the **show_telemetry** method.

### Variable Explorer

1. As you step through the **show_telemetry** method you will notice that Python variables are displayed in the **Variables Window**.

![Variable window](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-stepping-code-variable-window.png)

2. Right mouse click a variable, and you will discover you can change, copy, or watch variables. Try to change the value of a variable. **Hint**, double click on a variable value.

3. Press F5 to resume the Flask App, then switch back to your web browser and you will see the temperature, humidity, and pressure Sensor data displayed on the web page.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/flask-web-page.png)

4. Press the **Refresh** button on your web browser. The Flask app will again stop at the breakpoint in Visual Studio Code.

## Experiment with Debugger Options

Things to try:

1. Review the [Visual Studio Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial?WT.mc_id=pycon-blog-dglover)
1. Review the [Python Flask tutorial](https://vscode-westeu.azurewebsites.net/docs/python/tutorial-flask)
2. Review the [Visual Studio Code Debugging Tutorial](https://code.visualstudio.com/docs/editor/debugging?WT.mc_id=pycon-blog-dglover)
3. Try to change the value of a variable from the Visual Studio Code **Variable Window**.
4. Try setting a **conditional** breakpoint

    - Right mouse click directly in the margin to the left of the line number 22, select **Add Conditional Breakpoint...**. The breakpoint appears as a red dot with an equals sign in the middle:

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-conditional-breakpoint.png)
5. Try the Visual Studio Code **Debug Console**. This will give you access to the Python REPL, try printing or setting variables, importing libraries etc.

```python
print(temperature)

temperature = 24

import random
random.randrange(100, 1000)
```

![visual studio debug console](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-debug-console-print.png)

## Update the Flask Template

1. Update the Flask **index.html** template to display the current date and time.
2. Rerun the Flask app.

## Closing the Visual Studio Code Remote SSH

From Visual Studio Code, **Close Remote Connection**.

1. Click the **Remote SSH** button in the bottom left-hand corner and select **Close Remote Connection** from the dropdown list.

![close Remote SSH](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-close-ssh-session.png)

## Finished

![finished](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/congratulations.jpg)

## References

- [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover)
- [Python](https://www.python.org/)
- [Raspberry Pi](https://www.raspberrypi.org/)
- [Flask](https://www.fullstackpython.com/flask.html)
