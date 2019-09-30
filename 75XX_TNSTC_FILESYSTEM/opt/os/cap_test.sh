ls /dev/video* > /dev/null
if [ $echo $? == 0 ]
then
echo 1 > /opt/os/cap_sat
else
echo 0 > /opt/os/cap_sat
fi

