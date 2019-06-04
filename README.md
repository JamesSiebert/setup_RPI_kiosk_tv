# RPI_kiosk_tv
PUBLIC - An auto bash installer script that does the bulk of the setup for a Raspberry Pi to run as a TV. (Tested on RPI3B+, run from fresh 2019-04-08-raspbian-stretch install)


Prior to running script:
  Start > Preferences > Raspberry Pi Configuration
  Set your hostname
  Set your password
  Enable VNC

This is a little automation script that auto installs:
update
upgrade
pip
unclutter (for mouse pointer removal)
xscreensaver (for non blanking / time out)
download anydesk installer

Sets up config.txt
  hdmi
  1920x1080
  i2c
  spi
  
Sets up autostart
  autostart - for running a script on boot
  kiosk - for auto launching chrome in kiosk mode
  
Sets up crontab script to run 5pm every monday

reboot


After running script:
  Setup VNC
  Install and setup AnyDesk 
  
