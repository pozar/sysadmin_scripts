#!/usr/bin/perl

$ls = "/bin/ls -At";
$df = "/bin/df -k";
$grep = "/usr/bin/grep";
$lookfor = "*.mp3";
$dir = "/usr/local/var/nfsen/profiles-data/live/cr01-200p-sfo_em1/";
$percent = 85;

$fullfile = $dir . $lookfor;

open(LS_T, "$ls $fullfile |");
$i=0;
while(<LS_T>){
	chop;
	$filename[$i] = $_;
	$i++;
}

while(1){
	$result=`$df $dir | $grep -v Filesystem`;chop $result;
	$_ = $result;
	tr/ / /s;
	($fs,$kbytes,$used,$avail,$percentused,$mountedon) = split / /;
	chop $percentused;
	if ($percentused >= $percent){
		$i--;
		`rm $filename[$i]`;
	} else {
		exit;
	}
}
