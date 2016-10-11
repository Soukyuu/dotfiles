#!/bin/bash
echo 03 | sudo tee /sys/kernel/debug/dri/0/pstate > /dev/null
