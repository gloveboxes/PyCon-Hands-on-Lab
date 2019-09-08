# Lab 1: Debugging a Raspberry Pi Internet of Things Flask Application

|Author|[Dave Glover](https://developer.microsoft.com/en-us/advocates/dave-glover?WT.mc_id=pycon-blog-dglover), Microsoft Cloud Developer Advocate |
|----|---|
|Platforms | Linux, macOS, Windows, Raspbian Buster|
|Tools| [Visual Studio Code](https://code.visualstudio.com?WT.mc_id=pycon-blog-dglover)|
|Hardware | [Raspberry Pi 4. 4GB](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) model required for 20 Users. Raspberry Pi [Sense HAT](https://www.raspberrypi.org/products/sense-hat/), Optional: Raspberry Pi [case](https://shop.pimoroni.com/products/pibow-coupe-4?variant=29210100138067), [active cooling fan](https://shop.pimoroni.com/products/fan-shim)
|**USB3 SSD Drive**| To support up to 20 users per Raspberry Pi you need a **fast** USB3 SSD Drive to run Raspbian Buster Linux on. A 120 USB3 SSD drive will be more than sufficient. These are readily available from online stores.
|Language| Python|
|Date|As of September, 2019|

Follow me on Twitter [@dglover](https://twitter.com/dglover)

## PDF Lab Guide

You may find it easier to download and follow the PDF version of the [Debugging Raspberry Pi Internet of Things Flask App](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab1-ssh-debug/README.pdf) hands-on lab guide.

## Introduction

In this hands-on lab, you will learn how to create and debug a Python web application on a Raspberry Pi with [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover) and the [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover) extension. The web app will read the temperature, humidity, and air pressure telemetry from a sensor connected to the Raspberry Pi.

![Sense HAT for Raspberry Pi](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/rpi4-pi-sense-hat.jpg)

## Software Installation

![set up requirements](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/setup.jpg)

This hands-on lab uses Visual Studio Code. Visual Studio Code is a code editor and is one of the most popular **Open Source** projects on [GitHub](https://github.com/microsoft/vscode). It runs on Linux, macOS, and Windows.

### Install Visual Studio Code

1. **Install [Visual Studio Code](https://code.visualstudio.com/Download?WT.mc_id=pycon-blog-dglover)**

#### Visual Studio Code Extensions

The features that Visual Studio Code includes out-of-the-box are just the start. VS Code extensions let you add languages, debuggers, and tools to your installation to support your development workflow.

#### Browse for extensions

You can search and install extensions from within Visual Studio Code. Open the Extensions view from the Visual Studio Code main menu, select **View** > **Extensions** or by clicking on the Extensions icon in the **Activity Bar** on the side of Visual Studio Code.

![Extensions view icon](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/extensions-view-icon.png)

This will show you a list of the most popular VS Code extensions on the [VS Code Marketplace](https://marketplace.visualstudio.com/VSCode?WT.mc_id=pycon-blog-dglover).

<!-- ![popular extensions](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/extensions-popular.png) -->

![vs code install extension](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-install-extension.png)

### Install the Python and Remote SSH Extensions

Search and install the following two Visual Studio Code Extensions published by Microsoft.

1. **[Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python&WT.mc_id=pycon-blog-dglover)**
2. **[Remote - SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover)**

<!-- Install Visual Studio Code Extensions:

```bash
code --install-extension ms-vscode-remote.remote-ssh
code --install-extension ms-python.python
``` -->

## Remote SSH Development

The Visual Studio Code Remote - SSH extension allows you to open a remote folder on any remote machine, virtual machine, or container with a running SSH server and take full advantage of Visual Studio Code.

![Architecture Diagram](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/architecture-ssh.png)

## Raspberry Pi Hardware

If you are attending a workshop, then you can use a shared network-connected Raspberry Pi. You can also use your own network-connected Raspberry Pi for this hands-on lab.

You will need the following information from the lab instructor.

1. The **Network IP Address** of the Raspberry Pi
2. Your assigned **login name** and **password**.

## SSH Authentication with private/public keys

![ssh login](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/ssh-login.jpg)

Setting up a public/private key pair for [SSH](https://en.wikipedia.org/wiki/Secure_Shell) authentication is a secure and fast way to authenticate from your computer to the Raspberry Pi. This is recommended for this hands-on lab.

### SSH Set up for Windows Users

1. From Windows File Explorer, open **f<span>tp://\<Raspberry Pi Address>**

    ![Windows File Manager](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/windows-file-manager.png)

2. Copy the **windows-pylab** directory to your **desktop**
3. Open the **windows-pylab** folder you copied to your **desktop**
4. Double click **windows-ssh.cmd**

    You will be guided through the process of setting up an SSH key and copying the SSH public key to the Raspberry Pi.

### SSH for Linux and macOS Users

From a Linux or macOS **Terminal Console** or from **git bash** in windows run the following commands:

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

<!--
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

[SSH for earlier versions of Windows](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab2-docker-debug/resources/windows-ssh.md)

-->

## Start a Visual Studio Code Remote SSH Connection

1. **Start Visual Studio Code**
2. Press **F1** to open the Command Palette, type **ssh connect** and select **Remote-SSH: Connect to Host**

3. Select the **pylab-devnn** configuration

    ![open the ssh project](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-ssh-connection.png)

    It will take a moment to connect to the Raspberry Pi.

<!-- ## Install the Python Visual Studio Code Extension

![Python Extension](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-install-python.png)

Launch Visual Studio Code Quick Open (Ctrl+P), paste the following command, and press enter:

```bash
ext install ms-python.python
```

See the [Python Extension](https://marketplace.visualstudio.com/items?itemName=ms-python.python&WT.mc_id=pycon-blog-dglover) page for information about using the extension. -->

## Open Lab 1 SSH Debug Project

### Python Flask Web Apps

In this lab we are going to start and debug a [Flask](https://www.fullstackpython.com/flask.html) app. Flask is a popular Python Web Framework, powerful, but also easy for beginners.

1. From Visual Studio Code main menu: **File** > **Open Folder**
2. Select the **PyLab** directory
    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-folder-PyCon.png)
3. Next select the **Lab1-ssh-debug** directory
    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-folder-Lab1.png)
4. Click **OK** to Open the directory
5. From the **Explorer** bar, open the **app<span>.py** file and review the contents
    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-appy-py.png)

## Run the Python Flask App

1. Press **F5** to start the Python Flask app.
2. From the Visual Studio Code **Terminal Window**, click the **running on http://...** web link.
    ![Open web browser from VS Code](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-start-web-browser.png)
3. This will launch your desktop Web Browser.

    -  The Flask app will read the temperature, air pressure, humidity from the **sensor** attached the Raspberry Pi and display the results in your web browser.

    ![Flask Web Page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/flask-web-page.png)

## Set a Visual Studio Code Breakpoint

1. Switch back to Visual Studio Code and ensure the **app<span>.py** file is open.
2. Put the cursor on the line that reads **now = datetime.now()**
2. Use one of the following methods to set a breakpoint.
    - Press **F9**
    - From the main menu, select **Debug** > **Toggle Breakpoint**
    - **Click directly** in the **margin to the left** of the line number (a faded red dot appears when hovering there)
    
    **The breakpoint appears as a red dot in the left margin**

    ![Start the flask web application](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-flask-app.png)

3. Switch back to the **Web Browser** and click **Refresh**. The web page will **not response** as the Python code has been stopped by the debugger.
4. Switch back to **Visual Studio Code**. You will see that the code has stopped running at the **breakpoint**.

    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-stop-at-breakpoint.png)

## Stepping through Code with the Debugger

When a debug session starts, the **Debug toolbar** will appear at the top of the editor window.

The debugging toolbar (shown below) will appear in Visual Studio Code. It has the following options:

![Debug Actions](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/toolbar.png)

1. Pause (or Continue, F5),
1. Step Over (F10)
1. Step Into (F11),
1. Step Out (Shift+F11),
1. Restart (Ctrl+Shift+F5),
1. and Stop (Shift+F5).

To get started with debugging:

1. Step through the code by pressing (**F10**) or clicking **Step Over** on the debugging toolbar.
2. **Repeat** pressing **F10** until you reach the line that reads **if -40 <= temperature <= 60 and 0 <= pressure <= 1500 and 0 <= humidity <= 100:**
3. You will notice that Python variables are displayed in the **Variables Window**.

    ![Variable window](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-stepping-code-variable-window.png)

4. Try to change the **temperature** variable to **50**. Hint, **right mouse** click on the temperature variable and select **Set Value**, or double click on a **temperature** variable.
5. Press **F5** to resume the Flask App, then **switch back to your web browser** and you will see the temperature, humidity, and pressure Sensor data displayed on the web page.

<!-- ### Start the Flask App

1. Press F5 (or click the Run icon) to launch the **Python: Flask** debug configuration. This will start the Web Application on the Raspberry Pi in debug mode.

    ![Launch the Python: Flask Task](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-launch-debugger.png)

1. Ctrl+click the Flask Web link in the Visual Studio Terminal Window. This will launch your desktop Web Browser.

    ![Open web browser from VS Code](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-start-web-browser.png)

1. Next switch back to Visual Studio Code. The code execution has stopped at the breakpoint you set.



    ![Flask Web Page](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/flask-web-page.png)

1. Press the **Refresh** button on your web browser. The Flask app will again stop at the breakpoint in Visual Studio Code. -->

### Set a Conditional Breakpoint

Try setting a **conditional** breakpoint

1. Clear the existing breakpoints. From the main menu select **Debug** > **Remove all breakpoints**.
2. Ensure the **app<span>.py** file open.
3. **Right mouse click** directly in the margin to the **left** of the line number **22**.
    ![](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-add-conditional-breakpoint.png)
4. Select **Add Conditional Breakpoint...**
5. Set the condition to **temperature > 25**, then press **ENTER**

    ![Conditional BreakPoint in Visual Studio Code](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-conditional-breakpoint.png)

    The breakpoint appears as a red dot with an equals sign in the middle:
6. **Switch** back to your **web browsers** and **click refresh**. The web page will **not response** as the Python code has been stopped by the debugger.
7. **Switch** back to **Visual Studio Code** and you will see the debugger has stopped at the **conditional breakpoint**.
8. Press **F5** to continue running the code
9. **Switch** back to your **web browser** to view the page.

### Try the Debug Console

Try the Visual Studio Code **Debug Console**. This will give you access to the [Python REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop) (Read, Evaluate, Print Loop), try printing or setting variables, importing libraries, etc.

1. **Switch** back to your **web browser** and click refresh
2. **Switch** back to **Visual Studio Code**
3. The code should have stopped at the conditional breakpoint.
4. Select the Visual Studio **Debug Console** window.
    ![visual studio debug console](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-debug-console-print.png)
5. Type the following Python code into the Input Prompt **>**

    ```python
    print(temperature)
    ```

6. Press **Enter** to execute the Python code you typed.
7. Try running the following Python code snippets from the input prompt.

    ```python
    temperature = 24
    import random
    random.randrange(100, 1000)
    ```

8. Press **F5** to continue the execution of the Python code.
9. Switch back to you web browser to see the updated page.

## Lab Challenges

### Lab Challenge 1: Update the Flask Template

1. Update the Flask **index.html** template found in the **templates** folder to display the current date and time.
1. Rerun the Flask app.

### Lab Challenge 2: Experiment with Debugger Options

Things to try:

1. Review the [Visual Studio Code Python Tutorial](https://code.visualstudio.com/docs/python/python-tutorial?WT.mc_id=pycon-blog-dglover)
1. Review the [Python Flask tutorial](https://vscode-westeu.azurewebsites.net/docs/python/tutorial-flask)
1. Review the [Visual Studio Code Debugging Tutorial](https://code.visualstudio.com/docs/editor/debugging?WT.mc_id=pycon-blog-dglover)

## Review the **debug** options

1. Switch to Debug view in Visual Studio Code (using the left-side activity bar).

    ![open launch json file](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-open-launch-json.png)

1. Click the **Settings** button which will open the **launch.json** file.
1. The **launch.json** file defines how the Flask app will start, and what [Flask Command Line](https://flask.palletsprojects.com/en/1.0.x/cli/) parameters to pass at startup.

    There are two environment variables used in the launch.json file. These are **LAB_HOST** (which is the IP Address of the Raspberry Pi), and **LAB_PORT** (a random TCP/IP Port number between 5000 and 8000). These environment variables are set by the .bashrc script which runs when you connect to the Raspberry Pi with Visual Studio Remote SSH.

## Closing the Remote SSH Session

From Visual Studio Code, **Close Remote Connection**.

1. Click the **Remote SSH** button in the **bottom left-hand corner** and select **Close Remote Connection** from the dropdown list.

![close Remote SSH](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/vs-code-close-ssh-session.png)

## Finished

![finished](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/congratulations.jpg)

## References

- [Visual Studio Code](https://code.visualstudio.com/?WT.mc_id=pycon-blog-dglover)
- [Python](https://www.python.org/)
- [Raspberry Pi](https://www.raspberrypi.org/)
- [Flask](https://www.fullstackpython.com/flask.html)

## Trouble Shooting SSH Client Installation

- [Remote Development using SSH](https://code.visualstudio.com/docs/remote/ssh?WT.mc_id=pycon-blog-dglover)
- [Installing a supported SSH client](https://code.visualstudio.com/docs/remote/troubleshooting#_installing-a-supported-ssh-client?WT.mc_id=pycon-blog-dglover)