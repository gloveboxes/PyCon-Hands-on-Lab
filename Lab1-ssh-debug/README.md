# Lab 1: Remote Debugging a Raspberry Pi Flask or Bottle Web

In this hands-on lab, you will learn how to create a simple Flask or Bottle Web Application on a Raspberry Pi and debug with [Visual Studio Code](https://code.visualstudio.com/).

## References

- [Visual Studio Code](https://code.visualstudio.com/)
- [Python](https://azure.microsoft.com/en-au/services/iot-central/)
- [Raspberry Pi](https://www.raspberrypi.org/)
- [Flask](https://www.fullstackpython.com/flask.html)
- [Bottle](https://bottlepy.org)

## Lab Information

You need the following information for the Hands-on Lab.

1. The IP Address of the Raspberry Pi
1. Your **Raspberry user name**. The default password is **raspberry**.

## Hand-on Lab Overview

This is the flow of the Hands-on Lab:

1. Install the required software
2. Configuring SSH security
3. Connecting Visual Studio Code to the Raspberry Pi over SSH
4. Start the Web Application and attach the Visual Studio Code debugger

## Software Requirements

![set up requirements](resources/setup.jpg)

As at August 2019, **Visual Studio Code Insiders Edition** is required as it has early support for Remote Development over SSH.

Visual Studio Code is a source code editor and is one of the most popular Open Source projects on GitHub. It is supported on Linux, macOS, and Windows.

For information on contributing or submitting issues see the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). The documentation is also Open Source, you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

1. Install [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/)
1. Install the [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

## SSH Authentication with private/public keys

![ssh login](resources/ssh-login.jpg)

Setting up public/private keys for SSH login and authentication is a secure and fast way to authenticate with the Raspberry Pi and required for this hands-on lab.

The following creates a new SSH key, copies the public key to the Raspberry Pi. 

**Take the default options**.

### From Windows

1. Use the built-in Windows 10 (1809+) OpenSSH client. First, install the **OpenSSH Client for Windows** (one time only operation).

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
cat ~/.ssh/id_rsa.pub | ssh <Raspberry user name>@<Raspberry IP Address> "mkdir -p ~/.ssh; cat >> ~/.ssh/authorized_keys"
```

### From Linux, macOS, and the Windows Subsystem for Linux

1. Create your key. Typically a one-time operation.

```bash
ssh-keygen -t rsa
```

2. Copy the public key to your Raspberry Pi. From Linux and macOS.

```bash
ssh-copy-id <Your user name>@<Raspberry IP Address>
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

## Open the Lab2 Docker Debug Project

From **Visual Studio Code**, select **File** from the main menu, then **Open Folder**. Navigate to and open the **github/Lab1-ssh-debug** folder.

1. From VS Code: File -> Open Folder
2. Navigate to github/Lab1-ssh-debug directory
3. Open the **bottle-main.py** file
4. Scroll to the end of the file and update the **Raspberry Pi IP Address** with the IP Address allocated to you for the lab

    ```python
    if __name__ == '__main__':
        # Run the server
        app.run(host='<Raspberry PI IP Address>', port=port)
    ```

5. Save the file (Ctrl+S)
6. Set a Visual Studio Code breakpoint with a single click in the code gutter. Right where the red dot is in the image below. See [Visual Studio Code Debugging](https://code.visualstudio.com/docs/editor/debugging) for more information.
![Start the flask web application](resources/vs-code-flash-app.png)
7. Press F5 to start the Web Application

## Debug actions

Once a debug session starts, the **Debug toolbar** will appear on the top of the editor.

![Debug Actions](resources/toolbar.png)

- Continue / Pause `kb(workbench.action.debug.continue)`
- Step Over `kb(workbench.action.debug.stepOver)`
- Step Into `kb(workbench.action.debug.stepInto)`
- Step Out `kb(workbench.action.debug.stepOut)`
- Restart `kb(workbench.action.debug.restart)`
- Stop `kb(workbench.action.debug.stop)`
