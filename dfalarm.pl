#!/usr/local/bin/perl
$df = "/bin/df -k";
$grep = "/usr/bin/grep";
$mail = "/usr/bin/mail";
 
if($ARGV[2] eq ""){
	print ("Usage: dfalarm.pl partition level mailto\n");
	print ("	partition = drive partition with leading '/'\n");
	print ("	    level = percent full to act on\n");
	print ("	   mailto = who to send email to if over.\n");
}else{
	$fsystem = $ARGV[0];
	$percent = $ARGV[1];
	$mailto = $ARGV[2];
	$hostname=`hostname`;chop $hostname;
	$result=`$df $fsystem | $grep $fsystem`;chop $result;
	$_ = $result;
	tr/ / /s;
	($fs,$kbytes,$used,$avail,$percentused,$mountedon) = split / /;
	chop $percentused;
	if ($percentused >= $percent){
		$warning = "Warning: $fs aka $fsystem on $hostname is $percentused% full.";
		`echo $warning | $mail -s '$warning' $mailto`;
	}
}
