#!/usr/bin/perl -w

my $dir = $ARGV[0];
open OUT,">$dir/simu_completeness_avg";
for( my $rnd=1; $rnd<=10;$rnd++)
{
 my %iso;
 my @gnms = `cat $dir/ErrMax_Cuton_Cmpon/round$rnd/max_MC`;
 foreach my $gnm (@gnms)
 {
        my $seq;
	chomp $gnm;
	my $file = `ls $dir/$gnm.*fna`;
        open IN, "$file" || die "$!";
        while(<IN>)
        {
                chomp;
                if(!/>/)
                { $seq .= $_}
        }
        close IN;
        $iso{$gnm} = length($seq);
 }


 my %simu;
 foreach my $gnm (@gnms)
 {
	my $seq;
	chomp $gnm;
	$file = `ls $dir/ErrMax_Cuton_Cmpon/round$rnd/$gnm.*fasta`;
	open IN, "$file" || die "$!";
	while(<IN>)
	{
		chomp;
		if(!/>/)
		{ $seq .= $_}
	}
	close IN;
	$simu{$gnm} = length($seq);
 }

 my $cmp = 0;
 foreach my $gnm (@gnms)
 {
	$cmp = $cmp + $simu{$gnm}/$iso{$gnm};
#	print $gnm."\t".$cmp."\n";
 }
 my $avg_cmp = $cmp / scalar(@gnms);
 print OUT "round$rnd\t$avg_cmp\n";
}
close OUT;
