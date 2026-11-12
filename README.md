# Raspberry Pi 4 Embedded Linux System Monitor

## Project Overview
Raspberry Pi 4 system monitoring project, originally developed as part of my Master's in Computer Science at [CU Boulder](https://www.colorado.edu/).

The project serves as a hands-on learning experience in embedded Linux development, with a focus on Linux kernel module development, C programming and communication between kernel and user space. It implements basic system monitoring on the Raspberry Pi 4 using Buildroot, combining a custom kernel module with a user-space daemon and a lightweight web dashboard.

This is a learning-oriented project focused on exploring the Linux kernel and embedded systems rather than building a full-fledged monitoring platform. It currently targets the Raspberry Pi 4 only.

## Build Configuration for Raspberry Pi 4 Model B
Before building, make sure you are running an appropriate version of Ubuntu and all mandatory [buildroot dependencies](https://buildroot.org/downloads/manual/manual.html#requirement-mandatory) are installed.

After cloning the repository, load the default config, configure your WiFi credentials and build the image.

```bash
make config     # restores base_external/configs/raspberrypi4-64_sysmon_defconfig
```

### Configure WiFi

Copy example `wpa_supplicant.conf` into rootfs overlay:

```bash
cp base_external/board/raspberrypi4-64/examples/wpa_supplicant.conf.example \
   base_external/board/raspberrypi4-64/rootfs-overlay/etc/wpa_supplicant.conf
```

Replace WiFi credentials:

```bash
sed -i -e 's/YOUR_WIFI_NAME/<MyActualNetworkName>/' \
       -e 's/YOUR_WIFI_PASSWORD/<MyActualWifiPassword>/' \
       base_external/board/raspberrypi4-64/rootfs-overlay/etc/wpa_supplicant.conf
```

### Build Image
```bash
make
``` 

## Flash Image Onto SD Card
After building the image, you need to flash it onto your microSD card.

**1) Identify SD Card**
```bash
lsblk
```

Identify your SD card by its device name and capacity (ex. `sdb`).

**2) Unmount SD Card**
```bash
sudo umount /dev/sdX1   # X == whatever you identified to be your SD card
sudo umount /dev/sdX2
lsblk                   # make sure the device is unmounted
```

**3) Flash Image**
```bash
sudo dd if=buildroot/output/images/sdcard.img of=/dev/sdX bs=4M status=progress conv=fsync  # replace sdX with correct SD card identifier
sync
```

### System Monitoring Dashboard
From within your local network, open a web browser and go to `http://pi-sysmon:5000`.

You can use `test_dashboard_load` to simulate workload on the RPi and monitor changes in temperature, memory and CPU usage in real time. See [test/README.md](test/README.md) for how to get the test scripts onto the RPi.

## Network Configuration Notes
The default network configuration enables both Ethernet (`eth0`) and WiFi (`wlan0`).

When both interfaces are connected to the same network, the system removes duplicate Ethernet routes to ensure that WiFi remains the preferred LAN interface. This avoids routing conflicts when accessing the device over WiFi while Ethernet is connected.

