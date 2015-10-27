#!/usr/bin/perl

$full_list = $ARGV[0];
$test_list = $ARGV[1];
$train_list = $ARGV[2];

open FL, $full_list;
$nol = 0;
while ($l = <FL>)
{
	$nol++;
}
close FL;

$i = 0;
open FL, $full_list;
open TESTLIST, ">$test_list";
open TRAINLIST, ">$train_list";
while ($l = <FL>)
{
	chomp($l);
	
	# add Sample-xxx to trainlist and TSamples-xxxx to test list
	my $nth = substr($l, 0, 1);
	
	$i++;
	if ($nth eq 'T' )
	{
		print TRAINLIST "$l\n";
	}
	if ($nth eq 'S' )
	{
	    #rename $old_name, $new_name;
		print TRAINLIST "$l\n";
	}
	else
	{
		print TESTLIST "$l\n";
	}
}
