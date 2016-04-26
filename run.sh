#!/bin/bash
make
qemu-system-x86_64 -L . -m 64 -fda disk.img -M pc
