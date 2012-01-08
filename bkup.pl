#!/usr/bin/perl
# VARIABLES 

$CODELOC = "~/webapps/schedule";

$TMPLOC="/home/mrgschedule/tmp/backup"; # temp staging dir root
`rm -rf $TMPLOC`; # clean out old garbage
`mkdir -p $TMPLOC`; # make dirs if needed

#$DBLOC="$TMPLOC/db_backup"; #where we'll dump out DBs                       
$DBUSER = "mrgschedule_sch";
$DBPASS = "Rolleiflex";
#$BKUP_DRIVE = "/mnt/share";
#`mount $BKUP_DRIVE`;  # mount remote drive

$BKUP_DEST = "/home/mrgschedule/backup/";

# Create tar file name based on day of week                                     
use POSIX;
# use constant DATETIME => strftime("%Y-%m-%d_%H-%M-%S", localtime);
use constant DATETIME => strftime("%a", localtime);

# Create tar file name based on day of week
#@DAYNAME = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
#@timelist = localtime(time()); #list of sec,min,hr,day,mo,year,dow,doy
#$dayofweek = $timelist[6];
#$DATESTAMP=$DAYNAME[$dayofweek] ;

$DBFILENAME="DB_dump.sql";
$TARFILE = "schedule." . DATETIME . ".tar";

# First make a dump of the databases                                            
print "Exporting databases\n";
`cd "$TMPLOC"; /usr/bin/mysqldump --opt --all-databases -u $DBUSER --password=$DBPASS  > "$DBFILENAME"`;

# Create TAR file with code and DB dump
print "Creating TAR file " . $TARFILE . "\n";
`cd "$TMPLOC"; /bin/tar cvf "$TARFILE" "$DBFILENAME"`;

# Compress the file                                                             
print "Compressing TAR file\n";
`cd "$TMPLOC"; /bin/gzip --force "$TARFILE"`;

# Move gzip'd file to archive loc
print "Moving archive to " . $BKUP_DEST . "\n";
`cd "$TMPLOC"; /bin/mv -f "$TARFILE.gz" "$BKUP_DEST"`;

print "Removing temp files";
`rm -rf $TMPLOC`; # clean out old garbage

print "Done.\n";
