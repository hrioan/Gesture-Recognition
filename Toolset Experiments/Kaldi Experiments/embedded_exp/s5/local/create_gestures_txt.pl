#!/usr/bin/perl

$in_list = $ARGV[0];

open IL, $in_list;

while ($l = <IL>)
{
	chomp($l);
	$l =~ s/\.txt//;
	$trans = $l;
	$trans =~ s/_10/ freganiente /g;  
	$trans =~ s/_11/ ok /g;  
	$trans =~ s/_12/ cosatifarei /g;
	$trans =~ s/_13/ basta /g;
	$trans =~ s/_14/ prendere /g;
	$trans =~ s/_15/ noncenepiu /g;
	$trans =~ s/_16/ fame /g;
	$trans =~ s/_17/ tantotempo /g;
	$trans =~ s/_18/ buonissimo /g;		
	$trans =~ s/_19/ messidaccordo /g;
	$trans =~ s/_20/ sonostufo /g;
	$trans =~ s/_01/ vattene /g;
	$trans =~ s/_02/ vieniqui /g; 
	$trans =~ s/_03/ perfetto /g; 
	$trans =~ s/_04/ furbo /g; 
	$trans =~ s/_05/ cheduepalle /g; 
	$trans =~ s/_06/ chevuoi /g; 
	$trans =~ s/_07/ daccordo /g; 
	$trans =~ s/_08/ seipazzo /g; 
	$trans =~ s/_09/ combinato /g;  
	
	$trans =~ s/\d\d\d\d\d//g;
	$trans =~ s/\d\d\d//g;
	$trans =~ s/TSample//g;	
	$trans =~ s/Sil/ silencio /g;
	$trans =~ s/Sp/ shortpause /g;
	$trans =~ s/ISample//g;	
	$trans =~ s/Features//g;
	$trans =~ s/ZZ//g;
	$trans =~ s/\_//g;
	print "$l $trans\n";
}
