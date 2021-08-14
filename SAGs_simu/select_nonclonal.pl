#!/usr/bin/perl -w
#usage: perl cluster_summary.pl input
my $dir=$ARGV[0];
my $file = `ls $dir/tax*_0.000355362.txt.cluster.tab.txt`;
my %mainc; #indexed with main cluster id, pointed to an array of strains in this cluster
my %subc; #indexed with sub cluster id, pointed to an array of strains in this cluster
my %main_strains; #
open IN,"$file";
<IN>;
while(<IN>)
{
	chomp;
	my @a = split(/\t/);
	if($a[4]=~/,/)
	{
		my @b = split(/,/,$a[4]);
		#since the order of strains in clonal complex is same in each line,
		#store the first one and then can remove the redundant onces
		#my ($id) = $b[0] =~ /(\S+)\.fna/;
		my ($id) = $b[0] =~ /(GC\w_\d+)/;
		push @{$mainc{$a[2]}},$id;
		#push @{$subc{$a[1]}},$id;
	}
	else
	{
		#my ($id) = $a[4] =~ /(\S+)\.fna/;
		my ($id) = $a[4] =~ /(GC\w_\d+)/;
		push @{$mainc{$a[2]}},$id;
		#push @{$subc{$a[1]}},$id;

	}
}
close IN;

#get the main cluster with most strains (each clonal complex only counts one)
my $max=0;
my @selected; 
foreach (sort(keys %mainc))
{
	my @tmp = @{$mainc{$_}};
	my %seen =() ;
	@unique = grep { ! $seen{$_}++ } @tmp;
	foreach my $gnm(@unique)
	{
		`mv $dir/genome/$gnm.* $dir`;
	}
}

