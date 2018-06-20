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

# Note:
The script will also set python3 as the default python. If you don't want that, just run
`sudo ln -sfn /usr/bin/python2.7 /usr/bin/python`
afterwards.

The script automatically sets your keyboard to German.
If don't want that, change lines 10-12. Just replace "de" with "us", "en" or whatever your country code is.
I might add an option to do this in the settings later on.

# Credits:

Many steps are taken with small modifications from this seriously awesome blog:
https://www.pyimagesearch.com/2017/09/04/raspbian-stretch-install-opencv-3-python-on-your-raspberry-pi/
