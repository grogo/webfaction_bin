#!/bin/sh -f
export PYTHONPATH="/home/mrgschedule/webapps/schedule_cgi"
cd /home/mrgschedule/webapps/schedule_static
/usr/local/bin/python2.6 $PYTHONPATH/admin/schedule_latex.py 
/usr/bin/pdflatex schedule.tex



