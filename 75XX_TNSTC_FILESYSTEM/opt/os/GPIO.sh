#Battery Status 1
if [ -d /sys/class/gpio/gpio290 ]
 then
	echo "Battery Status 1 Already Exported"
 else
	echo 290 > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio290/direction
 fi
#Battery Status 2
if [ -d /sys/class/gpio/gpio292 ]
 then
 	echo "Battery Status 2 Already Exported"
 else
	echo 292 > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio292/direction
 fi
#3.8v Regulator
if [ -d /sys/class/gpio/gpio42 ]
 then
	echo "3.8v Regulator Already Exported"
 else
	echo 42 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio42/direction
 fi
#GPRS Enable
if [ -d /sys/class/gpio/gpio288 ]
 then
	echo "GPRS Enable Already Exported"
 else
	echo 288 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio288/direction
 fi
#GPRS Reset
if [ -d /sys/class/gpio/gpio289 ]
 then
	echo "GPRS Reset Already Exported"
 else
	echo 289 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio289/direction
 fi
#Sim Presence
if [ -d /sys/class/gpio/gpio169 ]
 then
	echo "Sim Presence Already Exported"
 else
	echo 169 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio169/direction
 fi
#Audio Enable
if [ -d /sys/class/gpio/gpio167 ]
 then
	echo "Audio Enable Already Exported"
 else
	echo 167 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio167/direction
 fi
#GPS Enable
if [ -d /sys/class/gpio/gpio174 ]
 then
	echo "GPS Enable Already Exported"
 else
	echo 174 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio174/direction
 fi
#Buzzer Enable
if [ -d /sys/class/gpio/gpio195 ]
 then
	echo "Buzzer Enable Already Exported"
 else
	echo 195 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio195/direction
 fi
#Future Enable
if [ -d /sys/class/gpio/gpio163 ]
 then
	echo "Future Enable Already Exported"
 else
	echo 163 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio163/direction
 fi
#RFID Enable
if [ -d /sys/class/gpio/gpio35 ]
 then
	echo "RFID Enable Already Exported"
 else
	echo 35 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio35/direction
 fi
#Finger Print Enable
if [ -d /sys/class/gpio/gpio166 ]
 then
	echo "Finger Print Enable Already Exported"
 else
	echo 166 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio166/direction
 fi
#Barcode Enable
if [ -d /sys/class/gpio/gpio196 ]                   
 then                                               
        echo "Barcode Enable Already Exported"                     
 else                                               
        echo 196 > /sys/class/gpio/export           
        echo out > /sys/class/gpio/gpio196/direction
 fi
#Barcode Trigger
if [ -d /sys/class/gpio/gpio197 ]                   
 then                                               
        echo "Barcode Trigger Already Exported"             
 else                                               
        echo 197 > /sys/class/gpio/export           
        echo out > /sys/class/gpio/gpio197/direction
 fi
#Paper Sense
if [ -d /sys/class/gpio/gpio162 ]
 then
	echo "Paper Sense Already Exported"
 else
	echo 162 > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio162/direction
 fi
