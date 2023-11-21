# Local control for Mitsubishi Electric Airco's

This repo is consolidating the instructions and helper scripts used for setting up ESP8266 or ESP32 devices for local control of Mitsubishi Electric Airconditioners.

You can control the units by using any of the following implementations (all of which are usually based on the [SwiCago/HeatPump](https://github.com/SwiCago/HeatPump) library):

*  [geoffdavis/esphome-mitsubishiheatpump](https://github.com/geoffdavis/esphome-mitsubishiheatpump)
*  [gysmo38/mitsubishi2MQTT](https://github.com/gysmo38/mitsubishi2MQTT)

:information_source: I tried both implementations and they work fine in my case with the following AC models: `MSZ-HR25VF`, `MSZ-AY42VG`

## Prerequisites

1.  Remove the plastic covers of your AC in order to familiarize yourself with the internals and locate the CN105 connector. It's usually in red with CN105 written right next to it.
1.  An ESP8266 or ESP32 device which you will physically connect to your AC using the CN105 port. I purchased the following parts:
   *   [Wemos D1 mini V4](https://a.aliexpress.com/_msr1zSy)
   *   [PAP-05V-S connector wires](https://a.aliexpress.com/_mLbGD1a)

1.  Connect/solder the wires _directly_ to the board as shown here: https://github.com/SwiCago/HeatPump/issues/13#issuecomment-1629319080
1.  Install Docker on your machine in order to run the steps from these instructions later

## Setting up the board for the first time

1.  Head over to: https://web.esphome.io
1.  Connect the MCU to your laptop using a USB-C cable
1.  Click on `Connect` and choose `Serial`
1.  Once connected, click on: `Prepare for first use` to flash a basic ESPHome which will allow you to configure the WiFi details and you'll be able to control the device remotely
1.  Find the IP address of the device
1.  Set up a DHCP reservation for the device so it'll always receive the same IP address
1.  Head over to "http://{IP_ADDR}" in order to flash any custom configurations/firmware using the steps below (you can also control the device from the web interface)

## Controlling the unit

### via ESPHome

1.  Edit the `secrets.yaml` file to provide your WiFi details
1.  Once the MCU is plugged in and connected to your WiFi, use this example command to upload the updated ESPHome firmware which will include the [geoffdavis/esphome-mitsubishiheatpump](https://github.com/geoffdavis/esphome-mitsubishiheatpump) climate component:

    ```shell
    docker run -it --rm \
      -v "${PWD}":/config \
      --entrypoint /config/entrypoint.sh \
      ghcr.io/esphome/esphome \
      my_office 192.168.1.2 run
    ```

### via mitsubishi2MQTT

1.  Once the MCU is plugged in and connected to your WiFi, use this example command to upload the [gysmo38/mitsubishi2MQTT](https://github.com/gysmo38/mitsubishi2MQTT) firmware binary on the device:

    ```shell
    docker run -it --rm \
      -v "${PWD}":/config \
      --entrypoint /config/entrypoint.sh \
      ghcr.io/esphome/esphome \
      my_office 192.168.1.2 upload mitsubishi2MQTT/mitsubishi2MQTT_WEMOS_D1_Mini_2023.8.0.bin
    ```

1.  The device will reboot and will start advertising a temporary WiFi network: `HVAC_XXXX`
1.  Set your WiFi defailts and click on "Save & Reboot"
1.  Set the MQTT information for use with Home Assistant
1.  (optional): Set up a Web password to prevent unwanted access in Setup -> Unit -> Web password -> Save & Reboot
1.  If you haven't disabled the MQTT autodiscovery in Home Assistant, you should see the device automatically appear

## Finally

Once you're done with the firmware flashing and you're able to communicate with the device remotely (using its IP address), connect the device to the `CN105` port and carefully place back all the plastic covers.

### Have fun!
