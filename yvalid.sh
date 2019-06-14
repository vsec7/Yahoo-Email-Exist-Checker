#!/usr/bin/env bash
# Yahoo Valid Checker
# By Viloid

GR='\033[92m'
RD='\033[91m'
NT='\033[0m'

valid(){
	curl -s 'https://login.yahoo.com/account/module/create?validateField=yid' \
	-H 'Cookie: APID=DA69a1ba67-a9bd-11e7-9a42-a0d3c10124eb; B="8rf81lpctc4k9&b=3&s=4m"; APIDTS=1560402461; AS=v=1&s=l6kxfBjt' \
	-H 'Origin: https://login.yahoo.com' \
	-H 'Accept-Encoding: gzip, deflate, br' \
	-H 'Accept-Language: en-US,en;q=0.9,id;q=0.8,ru;q=0.7' \
	-H 'User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Mobile Safari/537.36' \
	-H 'content-type: application/x-www-form-urlencoded; charset=UTF-8' \
	-H 'Accept: */*' \
	-H 'Referer: https://login.yahoo.com/account/create?specId=yidReg' \
	-H 'X-Requested-With: XMLHttpRequest' \
	-H 'Connection: keep-alive' \
	--data "browser-fp-data=%7B%22language%22%3A%22en-US%22%2C%22colorDepth%22%3A24%2C%22deviceMemory%22%3A8%2C%22pixelRatio%22%3A1%2C%22hardwareConcurrency%22%3A8%2C%22timezoneOffset%22%3A-420%2C%22timezone%22%3A%22Asia%2FBangkok%22%2C%22sessionStorage%22%3A1%2C%22localStorage%22%3A1%2C%22indexedDb%22%3A1%2C%22openDatabase%22%3A1%2C%22cpuClass%22%3A%22unknown%22%2C%22platform%22%3A%22Win32%22%2C%22doNotTrack%22%3A%22unknown%22%2C%22plugins%22%3A%7B%22count%22%3A3%2C%22hash%22%3A%22e43a8bc708fc490225cde0663b28278c%22%7D%2C%22canvas%22%3A%22canvas%20winding%3Ayes~canvas%22%2C%22webgl%22%3A1%2C%22webglVendorAndRenderer%22%3A%22Google%20Inc.~ANGLE%20(Intel(R)%20HD%20Graphics%20630%20Direct3D11%20vs_5_0%20ps_5_0)%22%2C%22adBlock%22%3A0%2C%22hasLiedLanguages%22%3A0%2C%22hasLiedResolution%22%3A0%2C%22hasLiedOs%22%3A0%2C%22hasLiedBrowser%22%3A0%2C%22touchSupport%22%3A%7B%22points%22%3A0%2C%22event%22%3A0%2C%22start%22%3A0%7D%2C%22fonts%22%3A%7B%22count%22%3A34%2C%22hash%22%3A%22b5bf706ac7146000d90e289f3884de54%22%7D%2C%22audio%22%3A%22124.0434474653739%22%2C%22resolution%22%3A%7B%22w%22%3A%221920%22%2C%22h%22%3A%221080%22%7D%2C%22availableResolution%22%3A%7B%22w%22%3A%221040%22%2C%22h%22%3A%221920%22%7D%2C%22ts%22%3A%7B%22serve%22%3A1560411521849%2C%22render%22%3A1560411533466%7D%7D&specId=yidReg&cacheStored=true&crumb=7BsreBA5.Wk&acrumb=l6kxfBjt&sessionIndex=&done=https%3A%2F%2Fwww.yahoo.com&googleIdToken=&authCode=&attrSetIndex=0&tos0=oath_freereg%7Cid%7Cid-ID&firstName=&lastName=&yid=$1&password=&shortCountryCode=ID&phone=&mm=&dd=&yyyy=&freeformGender=" \
	--compressed
}

check(){
	u=$(grep -oP '\K[^@]*' <<< "$1")
	v=$(valid $u | grep -oP '"name":"yid","error":"\K[^"]+')
	if [[ $v =~ "IDENTIFIER_EXISTS" ]]; then
		printf "[$d][$2/$c] ${GR}$1${NT}\n"
		echo "$1" >> yahoo-live.txt
	else
		printf "[$d][$2/$c] ${RD}$1${NT}\n"
		echo "$1" >> yahoo-die.txt
	fi
}

n=1
con=2

read -p "[?] Threads (Default 10) : " t
if [[ $t="" ]]; then
	t=10;
fi

read -p "[?] Sleep (Default 2) : " s
if [[ $s="" ]]; then
	s=2;
fi


cat $1 | grep "yahoo" > y.tmp
echo "[!] Found : $(cat y.tmp | wc -l) Yahoo Cleared"

for email in $(cat y.tmp); do
        f=$(expr $n % $t)
        if [[ $f == 0 && $n > 0 ]]; then
        	sleep $s
        fi
        d=$(date '+%H:%M:%S')
        c=$(cat $1 | wc -l)
        check $email $n &
        n=$[$n+1]
done
wait
