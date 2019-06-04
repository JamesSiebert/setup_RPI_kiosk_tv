#!/bin/sh

echo "Kiosk"

# Hide the mouse from the display
unclutter -idle 1 &

# If Chrome crashes (usually due to rebooting), clear the crash flag so we don't have the annoying warning bar
sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/pi/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/pi/.config/chromium/Default/Preferences

xset s noblank
xset -dpms
xset s off
echo "Starting browser"
chromium-browser --kiosk  --start-maximized --incognito http://www.google.com

sleep 5
echo "close me"