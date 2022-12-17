#!/bin/bash
~/klippy-env/bin/python ~/klipper/scripts/canbus_query.py can0
~/CanBoot/scripts/flash_can.py -i can0 -q
