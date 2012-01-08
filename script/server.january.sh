#!/bin/sh
cd /home/dvolkov/janteam
rails server -e production >log.txt 2>&1 &