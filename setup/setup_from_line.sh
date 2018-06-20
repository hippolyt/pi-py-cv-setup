#!/bin/bash
LINE=$1
bash <(tail -n +$LINE setup.sh)