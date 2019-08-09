# Lab 1: Remote Debugging a Raspberry Pi Flask or Bottle Web

In this hands-on lab, you will learn how to create and debug a Python web application on a Raspberry Pi with [Visual Studio Code](https://code.visualstudio.com/) and the [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh) extension.

## Remote Development using SSH

The Visual Studio Code Remote - SSH extension allows you to open a remote folder on any remote machine, virtual machine, or container with a running SSH server and take full advantage of VS Code's feature set. Once connected to a server, you can interact with files and folders anywhere on the remote filesystem.

No source code needs to be on your local machine to gain these benefits since the extension runs commands and other extensions directly on the remote machine.

![](resources/architecture-ssh.png)

## Software Installation

![set up requirements](resources/setup.jpg)

This hands-on lab uses Visual Studio Code. Visual Studio Code is a code editor and is one of the most popular **Open Source** projects on GitHub. It is supported on Linux, macOS, and Windows.

Install:

1. [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/)

    As at August 2019, **Visual Studio Code Insiders Edition** is required as it has early support for Raspberry Pi and Remote Development over SSH.

2. [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

For information on contributing or submitting issues see the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). Visual Studio Code documentation is also Open Source, and you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

## Raspberry Pi Hardware

You can complete this hands-on lab using your own network connected Raspberry Pi or if you are attending a workshop then you can use a shared network connected Raspberry Pi.

### Personal Raspberry Pi

If you using your own network connected Raspberry Pi, then you need the Raspberry Pi **Network IP Address**, the **login name** and **password**.

### Shared Raspberry Pi

If you are attending a workshop and using a shared Raspberry Pi then you will need the following information from the lab instructor.

1. The **Network IP Address** of the Raspberry Pi
2. Your assigned **login name** and **password.**.

## SSH Authentication with private/public keys

![ssh login](resources/ssh-login.jpg)

Setting up public/private keys for SSH login and authentication is a secure and fast way to authenticate with the Raspberry Pi and required for this hands-on lab.

The following creates a new SSH key, copies the public key to the Raspberry Pi.

### From Linux and macOS

1. Create your key. This is typically a one-time operation. **Take the default options**.

```bash
ssh-keygen -t rsa
```

2. Copy the public key to your Raspberry Pi. From Linux and macOS.

```bash
ssh-copy-id <Your user name>@<Raspberry IP Address>
```

### From Windows

1. Use the built-in Windows 10 (1809+) OpenSSH client. Install the **OpenSSH Client for Windows** (one time only operation).

    From **PowerShell as Administrator**.

```bash
Add-WindowsCapability -Online -Name OpenSSH.Client
```

2. From PowerShell, create your key. This is typically a one-time operation. **Take the default options**

```bash
ssh-keygen -t rsa
```

3. From PowerShell, copy the public key to your Raspberry Pi

```bash
cat ~/.ssh/id_rsa.pub | ssh <Raspberry user name>@<Raspberry IP Address> "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
```



## Configure Visual Studio Code Remote SSH Development

We need to tell Visual Studio Code the IP Address and user name we will be using to connect to the Raspberry Pi.

1. Start Visual Studio Code Insiders Edition

2. Click the **Open Remote Windows** button. You will find this button in the bottom left-hand corner of the Visual Studio Code window.

    ![select the user config file](resources/vs-code-open-remote-window.png)

3. Select **Open Configuration File**

    ![open configuration file](resources/vs-code-open-configuration.png)

4. Select the user .ssh config file

    ![select the user .ssh file](resources/vs-code-open-config-file.png)

5. Set the SSH connection configuration. You will need the IP Address of the Raspberry Pi and the user name assigned to you for the hands-on lab. Make the changes then save.

    ![configure host details](resources/vs-code-config-host-details.png)

6. Click the Open Remote Windows button (bottom left) then select **Remote SSH: Connect to Host**

    ![connect to host](resources/vs-code-connect-host.png)

7. Select the host **RaspberryPi** configuration

    ![open the ssh project](resources/vs-code-open-ssh-connection.png)

    It will take a moment to connect to the Raspberry Pi.

## Open the Lab 1 SSH Debug Project

From **Visual Studio Code**, select **File** from the main menu, then **Open Folder**. Navigate to and open the **github/Lab1-ssh-debug** folder.

1. From VS Code: File -> Open Folder
2. Navigate to github/Lab1-ssh-debug directory
3. Open the **app.py** file and review the contents
4. Set a breakpoint at the first line of code in the **show_telemetry** function (**now = datetime.now()**) by doing any one of the following:

    - With the cursor on that line, press F9, or,
    - With the cursor on that line, select the Debug > Toggle Breakpoint menu command, or, Click directly in the margin to the left of the line number (a faded red dot appears when hovering there). The breakpoint appears as a red dot in the left margin:

    ![Start the flask web application](resources/vs-code-flask-app.png)

5. Review the debug options.
    1. Switch to Debug view in Visual Studio Code (using the left-side activity bar). Along the top of the Debug view.

        ![open launch json file](resources/vs-code-open-launch-json.png)

    2. Click the **Settings** button which will open the **launch.json** file.
    3. The **launch.json** file defines how the the Flask app will be started, and what [Flask Command Line](https://flask.palletsprojects.com/en/1.0.x/cli/) parameters will passed on start up.

        There are two environment variables used in the launch.json file. These are **LAB_HOST** (which is the IP Address of the Raspberry Pi), and **LAB_PORT** (a random TCP/IP Port number between 5000 and 8000). These environment variables are set by the .bashrc script which runs when you connect to the Raspberry Pi with Visual Studio Remote SSH.

6. Press F5 (or click the Run icon) to launch the **Python: Flash** debug configuration. This will start the Web Application on the Raspberry Pi in debug mode.

    ![](resources/vs-code-launch-debugger.png)

## Debug actions

Once a debug session starts, the **Debug toolbar** will appear on the top of the editor.

![Debug Actions](resources/toolbar.png)

- Continue / Pause `kb(workbench.action.debug.continue)`
- Step Over `kb(workbench.action.debug.stepOver)`
- Step Into `kb(workbench.action.debug.stepInto)`
- Step Out `kb(workbench.action.debug.stepOut)`
- Restart `kb(workbench.action.debug.restart)`
- Stop `kb(workbench.action.debug.stop)`

## References

- [Visual Studio Code](https://code.visualstudio.com/)
- [Python](https://azure.microsoft.com/en-au/services/iot-central/)
- [Raspberry Pi](https://www.raspberrypi.org/)
- [Flask](https://www.fullstackpython.com/flask.html)
- [Bottle](https://bottlepy.org)


## Notes

- [Tutorial](https://vscode-westeu.azurewebsites.net/docs/python/python-tutorial)
- [Debugging](https://vscode-westeu.azurewebsites.net/docs/python/tutorial-flask)
- [Flask](https://vscode-westeu.azurewebsites.net/docs/python/debugging)
- [Jupyter](https://vscode-westeu.azurewebsites.net/docs/python/jupyter-support)
- 
- https://code.visualstudio.com/remote-tutorials/ssh/getting-started