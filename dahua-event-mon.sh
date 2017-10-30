## script makes http session to cam and monitors alarms
## when alarm occured action script is launching
## unique instance is assured by PID file
## continuity is/to be assured by cron
## 

PIDFILE=/tmp/${0##*/}.pid
if [ -f $PIDFILE ]
then
  PID=$(cat $PIDFILE)
  ps -p $PID > /dev/null 2>&1
  if [ $? -eq 0 ]
  then
    echo "Job is already running"
    exit 1
  else
    echo $$ > $PIDFILE
    if [ $? -ne 0 ]
    then
      echo "Could not create PID file"
      exit 1
    fi
  fi
else
  echo $$ > $PIDFILE
  if [ $? -ne 0 ]
  then
    echo "Could not create PID file"
    exit 1
  fi
fi

curl -s -N --user {user}:{password} --digest "http://{ip}:{port}/cgi-bin/eventManager.cgi?action=attach&codes=\[VideoMotion\]" | grep --line-buffered "Code=VideoMotion;action=Start" | while read LINE; do snapshot.sh; done

rm $PIDFILE
