#/bin/sh

#set -x

# Reference Number can be get from the recipet of the UK consulate
# The format is SHAN/XXXXX/XXXXX/1
# The birth month/day has to be in MM DD format 

REF_NUMBER=
BIRTH_DAY=
BIRTH_MON=
BIRTH_YEAR=

POLLING_INTERVAL_MINS=60
POLLING_INTERVAL=$(expr 60 \* $POLLING_INTERVAL_MINS)

ENCODE_STR="txtRefNO=$REF_NUMBER"
BIRTHDAY_STR="txtDat=$BIRTH_DAY&txtMont=$BIRTH_MON&txtYea=$BIRTH_YEAR"

STATUS=""
LAST_STATUS=""


URL="https://www.vfs.org.in/UKG-PassportTracking/ApplicantTrackStatus.aspx?Data=eQhlWV1635htWhLZVVgaKw==&ErrMsg=1"

function get_visa_status()
{
	STATUS=$(curl -s --cookie 'ASP.NET_SessionId=ss5mtnegrvxzbx55qxvom1ij' \
	     -A 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36' \
	     --data '__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=3UfJzWflvuBBlggXqBy3r%2BCUVb4Uw%2FjhKPYHfrIJHK3iV8NsxTtt3qSNq28exK422eEhcglgwLs2hv2R0ifAVrz73Nu23MafJLQsSw5Oi3jd7tgaspEva5IBJIKdSb40Njla%2BQ8LiNR03QEWjWZbOg%3D%3D&__VIEWSTATEENCRYPTED=&__EVENTVALIDATION=PzOwupzzo3iaHVnTrJ%2FsPl7HRm1P%2B%2F772vJZV5YaCv10Z9i5L9g3t5daMSjWKTFcVChDC8tL8F%2FMYKXRcjdgmQ%3D%3D&' \
	     --data-urlencode $ENCODE_STR  \
	     --data $BIRTHDAY_STR \
	     --data 'cmdSubmit=Submit' \
	     $URL \
	     | grep lblScanStatus | sed 's/\(.*\)px;">\(.*\)<\(.*\)><\(.*\)>/\2/') 
}

function notify_me()
{
	#clifetion email or whatever
	return
}

while [ 1 == 1 ]; 
do
	get_visa_status
	date
	if [ "$STATUS" != "" ]; then
		#echo $STATUS
		if [ "$LAST_STATUS" == "" ]; then
		#echo First Time
			echo "Initial Status:"
			LAST_STATUS=$STATUS
		elif [ "$LAST_STATUS" == "$STATUS" ]; then
			echo "No update"
			echo Status: $STATUS
		else 	
			echo "VISA Status Updated"
			echo Status: $STATUS
			notify_me
		fi		
	
	fi
	sleep $POLLING_INTERVAL
done

