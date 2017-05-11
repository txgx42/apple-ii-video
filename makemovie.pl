#!/usr/bin/perl

local $/ = undef;

open OUTFILE, ">movie.bin";
binmode OUTFILE;

$maxsize = 8388608;
$fsize = 0;
 
for ($frame=1; $frame<=5000; $frame++) {
	$fn = sprintf("%05dC.BIN", $frame);
	open INFILE, $fn or die "Couldn't open file: $!";
	binmode INFILE;
	$thisfile = <INFILE>;
	close INFILE;

	$outframe = "";

	for($b=0;$b<24;$b++) {
		$byte[$b] = 0;
	}
	for($line=0; $line<192; $line++) {
		$offset = $line * 40 + int($line/3) * 8;
		$b = int($line/8); 
		$t = ($line/8-$b) * 8;

		$thisfileline = substr $thisfile, $offset, 40;
		$lastfileline = substr $lastfile, $offset, 40;
		if($lastfileline ne $thisfileline) {
			$byte[$b] = $byte[$b] + 2**(7-$t);
			$outframe = $outframe.$thisfileline;
		}
	} 
	

	$bs = "";
	for($b=0;$b<24;$b++) {
		$bs = $bs.chr($byte[$b]);
	}
	
	$outframe = $bs.$outframe; 
	$l = pack('s', length $outframe);
	$outframe = $l.$outframe;

	if ($fsize + length $outframe <= $maxsize - 2) {
		print OUTFILE $outframe;
		$lastfile = $thisfile;
	} else {
		$frame -= 1; 
		print "Hit max file size, quitting after ".$frame." frames\n";
		last;
	}

	$fsize += length $outframe;
}

print OUTFILE pack('s', 65535);
close OUTFILE;


