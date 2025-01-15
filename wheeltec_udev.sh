echo  'KERNEL=="ttyUSB*", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE:="0777", SYMLINK+="fdilink_ahrs"' >/etc/udev/rules.d/wheeltec_fdi_imu_gnss.rules
sudo chmod 644 /etc/udev/rules.d/wheeltec_fdi_imu_gnss.rules
service udev reload
sleep 2
service udev restart
