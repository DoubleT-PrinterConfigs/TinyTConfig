#!/bin/bash
### Thanks to Eddie the engineer for providing examples on how to flash Klipper on different devices!!!

echo "Stopping Klipper..."
sudo service klipper stop
echo "Klipper has stopped"

### Flash Raspberry Pi linux Processor
echo "Start processing for Raspberry Pi"
make clean KCONFIG_CONFIG=config.rpi
make menuconfig KCONFIG_CONFIG=config.rpi
make flash  KCONFIG_CONFIG=config.rpi
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed linux process for Raspberry Pi"
else
   echo "*** Unable to flash linux process for Raspberry Pi"
fi

echo
echo ----------------------------------------------------------
echo

### Flash the SKR 3 via USB...
echo "Start processing for the SKR3..."
make clean KCONFIG_CONFIG=config.skr3
make menuconfig KCONFIG_CONFIG=config.skr3
make -j4 KCONFIG_CONFIG=config.skr3
make flash KCONFIG_CONFIG=config.skr3 FLASH_DEVICE=/dev/serial/by-id/usb-Klipper_stm32h743xx_270028001951303130373234-if00

# Sometimes the SKR3 is stuck in DFU mode...
if [ $? -eq 0 ]; then
   echo "*** Successfully flashed SKR3"
else
   echo "*** Unable to flash via serial path, attempting via USB device ID..."
   make flash KCONFIG_CONFIG=config.skr3 FLASH_DEVICE=0483:df11
fi

echo
echo ----------------------------------------------------------
echo

### Flash the SB2040 via CAN Boot...
#echo "Start processing for the SB2040..."
#make clean KCONFIG_CONFIG=config.sb2040
#make menuconfig KCONFIG_CONFIG=config.sb2040
#make -j4 KCONFIG_CONFIG=config.sb2040
#python3 ~/CanBoot/scripts/flash_can.py -i can0 -f ~/klipper/out/klipper.bin -u d063055012c2

echo "Starting Klipper..."
sudo service klipper start
echo "Klipper has started"
