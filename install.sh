#!/bin/bash
sleep 3
sudo raspi-config nonint do_vnc 0
sudo raspi-config nonint do_ssh 0
sudo raspi-config nonint do_i2c 0
sleep 5
cd
git clone https://github.com/Freenove/Freenove_4WD_Smart_Car_Kit_for_Raspberry_Pi.git
pyv="$(python -V 2>&1)"
echo "Current Version = $pyv"
pyv_cut=$(echo "$pyv" | awk -F ' ' '{print$2}')
pyv_cut=$(echo "$pyv_cut" | awk -F '.' '{print$1}')
#echo $pyv_cut "Python Version"
if [[ $pyv_cut -lt  3 ]]
then
    echo "$pyv needs upgraded"
    cd /usr/bin
    sudo rm python
    sudo ln -s python3 python
    pyv="$(python -V 2>&1)"
    echo "Upgraded to" $pyv
else
    echo "$pyv is good to go"
        
fi
lsmod | grep i2c
sudo apt-get install i2c-tools -y
sudo apt-get install python3-smbus -y
i2cdetect -y 1
sudo echo -n "blacklist snd_bcm2835" > /etc/modprobe.d/snd-blacklist.conf
sudo sed -i -e 's/dtparam=audio=on/# dtparam=audio=on/' /boot/config.txt
test=$(echo 'Script Works') && curl -d "Here is the sparky script: $test" ntfy.sh/cp_sparky
echo "Restarting Pi"
sleep 5
sudo reboot now