#!/bin/sh -f
export PYTHONPATH="/home/mrgschedule/webapps/schedule_cgi"
cd /home/mrgschedule/webapps/schedule_static
/usr/local/bin/python2.6 $PYTHONPATH/admin/schedule_latex.py 
/usr/bin/pdflatex -interaction batchmode schedule.tex

# email completed schedule PDF to myself
/usr/bin/mutt -a schedule.pdf -s Schedule  xeladog99@gmail.com < schedule.log


