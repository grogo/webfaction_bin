#!/usr/bin/perl
# VARIABLES 

use warnings;
use strict;
use POSIX;
use constant DATETIME => strftime("%Y%m%d", localtime);

my $ROOT = "/home/mrgschedule";

#$CODELOC = "/home/mrgschedule/webapps";
my $REPOSLOC = "$ROOT/repos";

my $TMPLOC="$ROOT/tmp/backup"; # temp staging dir root
`rm -rf $TMPLOC`; # clean out old garbage
`mkdir -p $TMPLOC`; # make dirs if needed

my $BKUP_DEST = "$ROOT/backup/";

#$DBLOC="$TMPLOC/db_backup"; #where we'll dump out DBs                       

my @backups = (
	       {name=>'schedule',
		db=>'mrgschedule_sch',
		user=>'mrgschedule_sch',
		pass=>'Rollei66flex',
		dir=>'schedule_cgi'},

	       {name=>'phonebook',
		db=>'mrgschedule_phon',
		user=>'mrgschedule_phon',
		pass=>'Rollei66flex',
		dir=>'phonebook3'},

	       {name=>'bank',
		db=>'mrgschedule_dj',
		user=>'mrgschedule_dj',
		pass=>'Rolleiflex',
		dir=>'bank'},

	       # {name=>'blog',
	       # 	db=>'mrgschedule_rad_',
	       # 	user=>'mrgschedule_rad_',
	       # 	pass=>'OusEYuEX',
	       # 	dir=>'rad_site'},

	       {name=>'new_blog',
		db=>'mrgschedule_drp8',
		user=>'mrgschedule_drp8',
		pass=>'0XuV9EAy',
		dir=>'drp8_drupal8'},

	       {name=>'static',
		db=>'',
		user=>'',
		pass=>'',
		dir=>'schedule_static'},

	       {name=>'vacation',
		db=>'',
		user=>'',
		pass=>'',
		dir=>'vacation2'},

	       );


for (my $i=0; $i < scalar(@backups); $i++)
{
    print "Backing up $backups[$i]{'name'}\n";
#     print $backups[$i]{'db'}."\n";
#     print $backups[$i]{'dir'}."\n";
    
# Create tar file name based on day of week                                     
    
# Create tar file name based on day of week
#@DAYNAME = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat");
#@timelist = localtime(time()); #list of sec,min,hr,day,mo,year,dow,doy
#$dayofweek = $timelist[6];
#$DATESTAMP=$DAYNAME[$dayofweek] ;

#     $DBFILENAME="DB_dump.sql";
#     $TARFILE = "schedule.weekly." . DATETIME . ".tar";
    my $NAME = $backups[$i]{'name'};
    # print $backups[$i]{'db'}."\n";
    # print $backups[$i]{'dir'}."\n";
    my $DBFILENAME="$NAME.DB_dump.sql";
    my $TARFILE = "$NAME.weekly." . DATETIME . ".tar";
    my $DBUSER = $backups[$i]{'user'};
    my $DBPASS = $backups[$i]{'pass'};
    my $DBNAME = $backups[$i]{'db'};
    my $CODELOC = $ROOT."/webapps/".$backups[$i]{'dir'};

# Create tar file with code
    print "Appending code and repositories\n";
    `cd "$TMPLOC"; /bin/tar cvf "$TARFILE" "$CODELOC"`;
    
    if($DBNAME ne ''){  # ignore blank databases, just bkup files

# make a dump of the databases                                            
	print "Exporting databases\n";
	`cd "$TMPLOC"; /usr/bin/mysqldump --opt --all-databases -u $DBUSER --password=$DBPASS  > "$DBFILENAME"`;
    
# Append DB dump
	print "Creating TAR file " . $TARFILE . "\n";
	`cd "$TMPLOC"; /bin/tar rvf "$TARFILE" "$DBFILENAME"`;
    }
#    `cd "$TMPLOC"; /bin/tar rvf "$TARFILE" "$REPOSLOC"`;
    
# Compress the file                                                             
    print "Compressing TAR file\n";
    `cd "$TMPLOC"; /bin/gzip --force "$TARFILE"`;
    
# Move gzip'd file to archive loc
    print "Moving archive to " . $BKUP_DEST . "\n";
    `cd "$TMPLOC"; /bin/mv -f "$TARFILE.gz" "$BKUP_DEST"`;
    
}
print "Removing temp files\n";
`rm -rf $TMPLOC`; # clean out old garbage

print "Done.\n";
