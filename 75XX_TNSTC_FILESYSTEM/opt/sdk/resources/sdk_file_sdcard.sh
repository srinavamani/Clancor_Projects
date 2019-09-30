#!/bin/bash

app="[A]pplication"
path="/media/sdcard/"
echo $app
#app1=`echo $app | cut -c2`
#app2=`echo $app | cut -c4-`
#echo [$app1]
#echo $app1$app2
#app3="[$app1]"
#app3+="$app2"
#echo app $app3

chech_sh=`cat /tmp/chech_sh`
echo $chech_sh
if [ $chech_sh == "0" ]
then
echo 1 > /tmp/chech_sh
var=`ps | grep $app | awk {'print $5'}`
var1=`echo $var | awk {'print $1'}`
#var2=`echo $var | awk {'print $4'}`
echo $var
echo $var1
#echo $var2


if [ $var1 == $path$app ]
then
echo "already running"
echo 0 > /tmp/chech_sh
#elif [ $var2 == $1 ]
#then
#echo "already running1"
#echo 0 > /tmp/chech_sh
else
echo "not running"
export DISPLAY=:0.0
$path$app 2>/home/root/LOG &
sleep 2
echo 0 > /tmp/chech_sh
fi
else
echo "script already running"
fi

