#!/bin/bash
find "${1}" -type f -exec md5sum {} \;>> "${1}/checksums.md5"
