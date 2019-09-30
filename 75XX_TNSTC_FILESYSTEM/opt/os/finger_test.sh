status=`lsusb | grep Sagem | awk '{print $7}'`

if [ '$status' == "Sagem" ]
then
	echo 1 > /home/root/fp_sat
else
	echo 0 > /home/root/fp_sat
fi

