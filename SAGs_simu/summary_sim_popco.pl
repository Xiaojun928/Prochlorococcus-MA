#!/usr/bin/perl -w

my $dir1 = $ARGV[0];
my $dir2 = "ErrMax_Cuton_Cmpon";
my ($taxa) = $dir1 =~ /(\S+)_taxa\d+/;
open OUT,">Summary/$taxa\_popco_summary.txt" || die "$!";
print OUT "rnd\tMCid\t#gnms\tgenomes\n";
`cp $dir1/$dir2/round*/*.cluster.tab.txt $dir1/$dir2`;
my @list = `ls $dir1/$dir2/*_0.000355362.txt.cluster.tab.txt`;
foreach my $file(@list)
{
	my %hash;
	my %cnt; #indexed with MC id, pointed to the number of strains
	my ($rnd) = $file =~ /ErrMax_Cuton_Cmpon\/(\S+)_0.000355362.txt.cluster.tab.txt/;
	#my ($rnd) = $file =~ /\/\/(\S+)_0.000355362.txt.cluster.tab.txt/;
	open IN,"$file" || die "$!";
	<IN>;
	while(<IN>)
	{
		my @a = split(/\t/);
		my ($gca) = $a[0] =~ /(GC[A|F]_\d+)/;
		#my ($gca) = $a[0] =~ /(\S+)\.fna/;
		push @{$hash{$a[2]}},$gca;
		$cnt{$a[2]} += 1;
	}
	close IN;
	foreach my $mc (keys(%hash))
	{
		my $gnms = join(":",sort(@{$hash{$mc}}));
		#print OUT $rnd."\t".$mc."\t".$cnt{$mc}."\t".$hash{$mc}."\n";
		print OUT $rnd."\t".$mc."\t".$cnt{$mc}."\t".$gnms."\n";
	}
	print OUT "==\n";
}
close OUT;
