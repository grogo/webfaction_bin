#!/bin/sh -f
export PYTHONPATH="/home/mrgschedule/webapps/schedule_cgi"

cd /home/mrgschedule/webapps/schedule_static
mkdir -p calendars
/usr/local/bin/python2.6 $PYTHONPATH/utils/goocal.py
