#!/bin/bash
echo 0f | sudo tee /sys/kernel/debug/dri/0/pstate > /dev/null
