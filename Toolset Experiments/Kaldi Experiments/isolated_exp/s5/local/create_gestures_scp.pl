#!/usr/bin/perl

$ges_dir = $ARGV[0];
$in_list = $ARGV[1];

open IL, $in_list;

while ($l = <IL>)
{
	chomp($l);
	$full_path = $ges_dir . "\/" . $l;
	$l =~ s/\.txt//;
	print "$l $full_path\n";
}
