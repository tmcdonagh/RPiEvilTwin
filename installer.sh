#!/bin/bash
# Script that just automates the installation a little bit

cd clouddb/
./installer.sh
cd ..

cd web
./installer.sh
cd ..

cd clouddb/
./networkCreator.sh
cd ..
