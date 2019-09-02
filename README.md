# PyCon 2019

## Debug Python with Visual Studio Code: Tips and Tricks Tutorial

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

## Tutorial Description

### Python Debugging: Pro Tips and Not-So-Obvious Tricks

If you are anything like me, when you started with Python 'print' was the debugger of choice. But you likely found that was slow, tedious, and didn't cut it for more complex problems.

Let’s dive into methods for debugging remote python in environments such as CircuitPython, Raspberry Pi, Docker containers, remote Linux Servers, and Jupyter Notebooks.

You’ll learn how to sync code to devices, attach debuggers, and step through your code. And existing (or newly forged) Jupyter fans will learn tips to debug your notebooks.

This fun session covers a range of scenarios and empowers you to supercharge your debugging techniques!

## Personal Computer Requirements

1. Bring your own laptop running one of the follow Operating Systems:

    - Linux
        - See [Installing Visual Studio Code on Linux](https://code.visualstudio.com/docs/setup/linux)
    - macOS
    - Windows 10 (1809+).
        - Install the OpenSSH Client from PowerShell as Administrator.

        ```bash
        Add-WindowsCapability -Online -Name OpenSSH.Client
        ```

2. You will have access to a network shared Raspberry Pi. Feel free to bring your own Raspberry Pi (model with WiFi required), must have a unique network/host name.

## Software Installation

![set up requirements](https://raw.githubusercontent.com/gloveboxes/PyCon-Hands-on-Lab/master/Lab1-ssh-debug/resources/setup.jpg)

This hands-on lab uses Visual Studio Code. Visual Studio Code is a code editor and is one of the most popular **Open Source** projects on GitHub. It is supported on Linux, macOS, and Windows.

Install:

1. [Visual Studio Code Insiders Edition](https://code.visualstudio.com/insiders/?WT.mc_id=pycon-blog-dglover)

    As at August 2019, **Visual Studio Code Insiders Edition** is required as it has early support for Raspberry Pi and Remote Development over SSH.

2. [Remote - SSH Visual Studio Code Extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh&WT.mc_id=pycon-blog-dglover)

For information on contributing or submitting issues see the [Visual Studio GitHub Repository](https://github.com/microsoft/vscode). Visual Studio Code documentation is also Open Source, and you can contribute or submit issues from the [Visual Studio Documentation GitHub Repository](https://github.com/microsoft/vscode-docs).

## Debugging Web and Docker Container Apps on a Raspberry Pi

![](resources/rpi4-pi-sense-hat.jpg)

- [Lab 1: Remote Debugging a Raspberry Pi Flask Web Application](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab1-ssh-debug/README.md)
- [Lab 2: Raspberry Pi, Python, IoT Central, and Docker Container Debugging](https://github.com/gloveboxes/PyCon-Hands-on-Lab/blob/master/Lab2-docker-debug/README.md)


## Dev.to (Works with Google Translate)

- [Lab 1: Remote Debugging a Raspberry Pi Flask Web Application]()

- [Lab 2: Raspberry Pi, Python, IoT Central, and Docker Container Debugging]()