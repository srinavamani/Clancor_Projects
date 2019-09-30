case "$1" in
ON)
	echo 1 > /sys/class/gpio/gpio35/value
	echo 1 > /sys/class/gpio/gpio109/value
;;
OFF)
	echo 0 > /sys/class/gpio/gpio35/value
	echo 0 > /sys/class/gpio/gpio109/value
;;
*)
echo "Usage: sh nfc.sh {ON|OFF}"                       
        exit 1                                                                  
        ;;
esac
