#!/bin/bash
set -o xtrace  # print the commands before executing
set -e  # Exit on any error inside script


echo "First boot? [y/n]"
read FIRST_BOOT
if [ "$FIRST_BOOT" = "y" ]; then
	# Set keyboard to german and expand filesystem
	sudo sed -i 's/XKBLAYOUT=".*"/XKBLAYOUT="de"/g' /etc/default/keyboard
	setxkbmap de
	echo "setxkbmap de" >> ~/.bashrc 
	sudo raspi-config --expand-rootfs
	
	# Configure Wifi
	cp ~/setup/data/wpa_supplicant.conf.orig ~/setup/data/wpa_supplicant.conf
	SSID=$(cat ~/setup/settings/wifi-ssid)
	PASSWORD=$(cat ~/setup/settings/wifi-pw)
	sed -i "s/SSID/$SSID/g" ~/setup/data/wpa_supplicant.conf
	sed -i "s/PASSWORD/$PASSWORD/g" ~/setup/data/wpa_supplicant.conf
	sudo cp ~/setup/data/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant.conf
	sudo cp ~/setup/data/interfaces /etc/network		# Fix the file the official Pi update usually breaks

	# Reboot
	sudo reboot
fi	


# Link standard python and pip binaries to python2.7
sudo ln -sfn /usr/bin/python2.7 /usr/bin/python


# Clean up
sudo apt-get purge -y wolfram-engine
sudo apt-get purge -y libreoffice*
sudo apt-get clean -y
sudo apt-get autoremove -y
echo $LINENO > ~/setup/checkpoint


# Update
sudo apt-get update
sudo rpi-update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y
sudo cp ~/setup/data/interfaces /etc/network		# Fix the file the official Pi update usually breaks
echo $LINENO > ~/setup/checkpoint


# Install Software
sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y python2.7-dev python3-dev
echo $LINENO > ~/setup/checkpoint


# Download OpenCV
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/3.4.1.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.4.1.zip
unzip opencv_contrib.zip
echo $LINENO > ~/setup/checkpoint


# Get Python environment ready
sudo apt-get install -y python-pip python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install --upgrade setuptools
sudo rm -rf ~/.cache/pip
echo $LINENO > ~/setup/checkpoint


# Install python packages
sudo pip3 install numpy
echo $LINENO > ~/setup/checkpoint


# Install Opencv
cd ~/opencv-3.4.1/
rm -rf build
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D BUILD_opencv_python3=On \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.4.1/modules \
      -D BUILD_EXAMPLES=ON ..
echo $LINENO > ~/setup/checkpoint


# Expand Swap size for faster CV compilation
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=1024/g' /etc/dphys-swapfile 
sudo cat /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
echo $LINENO > ~/setup/checkpoint


# Make Opencv
cd ~/opencv-3.4.1/build
make -j4
sudo make install
sudo ldconfig
echo $LINENO > ~/setup/checkpoint


# Make Links work right
cd /usr/local/lib/python3.5/dist-packages/
sudo mv cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so
echo $LINENO > ~/setup/checkpoint 		


# Test OpenCV
python3 -c 'import cv2;print(cv2.__version__)'
echo $LINENO > ~/setup/checkpoint


# Remove unnecessary files
rm -rf ~/opencv*
echo $LINENO > ~/setup/checkpoint


# Turn Swap size back again for longer SD lifetime 
sudo sed -i 's/CONF_SWAPSIZE=.*/CONF_SWAPSIZE=100/g' /etc/dphys-swapfile
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
echo $LINENO > ~/setup/checkpoint


# Link all python and pip binaries to python3
sudo ln -sfn /usr/bin/python3 /usr/bin/python

