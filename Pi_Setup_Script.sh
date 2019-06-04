#!/usr/bin/env bash

read -p "Set hostname, password, enable VNC First. Enter to continue" nothing

apt-get update
echo "------------------- UPDATE COMPLETE -------------------"

sleep 1
apt-get upgrade -y
echo "------------------- UGRADE COMPLETE -------------------"

sleep 1
apt-get install python-pip -y
echo "------------------- python-pip INSTALL COMPLETE -------------------"

sleep 1
# unclutter - Hides cursor
apt-get install unclutter -y
echo "------------------- unclutter INSTALL COMPLETE -------------------"

sleep 1
# xscreensaver - Screen saver override
apt-get install xscreensaver -y
echo "------------------- xscreensaver INSTALL COMPLETE -------------------"

sleep 1
dpkg -i /home/pi/RPI_kiosk_tv/install_me/anydesk_2.9.4-1_armhf.deb
echo "------------------- AnyDesk INSTALL COMPLETE -------------------"

sleep 1
# ---------------------- PI BOOT CONFIG -------------------------------------
# The Pi Config File Location
PI_CONFIG="/boot/config.txt"

# HDMI Setup
#ref:https://core-electronics.com.au/tutorials/create-an-installer-script-for-raspberry-pi.html

# If a line containing "#hdmi_force_hotplug=1" exists
if grep -Fq "hdmi_force_hotplug" $PI_CONFIG
then
	# Replace the line
	echo " replacing hdmi_force_hotplug"
	sed -i "/hdmi_force_hotplug/c\hdmi_force_hotplug=1" $PI_CONFIG
else
    # Create the definition
	echo "#hdmi_force_hotplug=1 not found, SKIP"
fi

if grep -Fq "hdmi_group" $PI_CONFIG
then
	# Replace the line
	echo " replacing hdmi_group"
	sed -i "/hdmi_group/c\hdmi_group=2" $PI_CONFIG
else
	echo "#hdmi_group not found, SKIP"
fi

if grep -Fq "hdmi_mode" $PI_CONFIG
then
	# Replace the line
	echo " replacing hdmi_mode"
	sed -i "/hdmi_mode/c\hdmi_mode=82" $PI_CONFIG
else
	echo "#hdmi_mode not found, SKIP"
fi

# Enable I2C & SPI
if grep -Fq "dtparam=i2c_arm" $PI_CONFIG
then
	# Replace the line
	echo " replacing dtparam=i2c_arm"
	sed -i "/dtparam=i2c_arm/c\dtparam=i2c_arm=on" $PI_CONFIG
else
	echo "#dtparam=i2c_arm not found, SKIP"
fi

if grep -Fq "dtparam=spi" $PI_CONFIG
then
	# Replace the line
	echo " replacing dtparam=spi"
	sed -i "/dtparam=spi/c\dtparam=spi=on" $PI_CONFIG
else
	echo "#dtparam=i2c_arm not found, SKIP"
fi
echo "------------------- BOOT CONFIG COMPLETE -------------------"

sleep 1
# Location of the autostart file
desktop_file=/home/pi/.config/autostart/autostart.desktop

if [[ ! -d "/home/pi/.config/autostart" ]];
then
	echo "no autostart folder found"
	sleep 2
	mkdir /home/pi/.config/autostart
	echo "Created Autorun folder"
fi

if [[ ! -e "$desktop_file" ]];
then
	touch "$desktop_file"
	echo "Created autostart.desktop"
else
	echo "autostart.desktop exists"
fi

echo "Writing autostart contents"
/bin/cat <<EOM >///"$desktop_file"
[Desktop Entry]
Type=Application
Name=autostart
Exec=lxterminal -e python3 /home/pi/RPI_kiosk_tv/boot_script.py
EOM



sleep 1
# Location of kiosk autostart
kiosk_file=/home/pi/.config/autostart/kiosk.desktop

if [[ ! -e "$kiosk_file" ]];
then
	touch "$kiosk_file"
	echo "Created kiosk.desktop"
else
	echo "kiosk.desktop exists"
fi

echo "Writing kiosk contents"
/bin/cat <<EOM >///"$kiosk_file"
[Desktop Entry]
Type=Application
Name=kiosk
Exec=lxterminal -l -e '/home/pi/RPI_kiosk_tv/kiosk.sh ; /bin/bash '
EOM


echo "------------------- AUTOSTART COMPLETE -------------------"

sleep 1
cp -v /home/pi/RPI_kiosk_tv/.xscreensaver /home/pi/.xscreensaver
echo "------------------- XScreensaver Settings Done -------------------"

sleep 1
# Set for 5pm mondays
CRON_FILE="/var/spool/cron/crontabs/root"

if [ ! -f $CRON_FILE ]; then
   echo "cron file for root doesnot exist, creating.."
   touch $CRON_FILE
   /usr/bin/crontab $CRON_FILE
fi

grep -qi "cron_script" $CRON_FILE
if [ $? != 0 ]; 
then
   echo "Updating cron job for device_reboot"
   /bin/echo "0 17 * * 1 /home/pi/cron_script.sh" >> $CRON_FILE
fi
echo "------------------- CronTab Done -------------------"

echo "To Do:"
echo "install & setup AnyDesk (install_me folder)"
echo "setup VNC"
read -p "All Done? Press Enter" nothing

sleep 1
echo "INSTALL SCRIPT COMPLETE, rebooting."
sleep 10

reboot
