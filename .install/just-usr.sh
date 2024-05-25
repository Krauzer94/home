#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/bin
curl -LJO https://raw.githubusercontent.com/Krauzer94/home/main/.justfile
