# pi-py-cv-setup
Get a raspberry pi and opencv with python3 acquainted. It is like a drinking game. Just leave them alone with this script, and they will sort out the rest between themselves.

# Installation:
Just do this on your Pi:

```
git clone https://github.com/hippolyt/pi-py-cv-setup
cd pi-py-cv-setup
cp -r setup /home/pi
cd /home/pi/setup
echo "MYWIFISSID" > /home/pi/setup/settings/wifi-ssid
echo "MYWIFIPW" > /home/pi/setup/settings/wifi-pw
chmod +x *.sh
./setup.sh
```

Finished!


# Credits:

Many steps are taken with small modifications from this seriously awesome blog:
https://www.pyimagesearch.com/2017/09/04/raspbian-stretch-install-opencv-3-python-on-your-raspberry-pi/
