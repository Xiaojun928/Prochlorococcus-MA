#!/usr/bin/perl -w

my $dir = $ARGV[0];
#my $ortho_re = $ARGV[1];
##1. get the map of gene to famid, and map of gene to seq
my @list1=`ls $dir/00_seq_folder/*faa`;
#my %hash; #indexed with gene name, pointed to famid;
my %seq;
foreach my $file (@list1)
{
	open IN,"$file" || die "can't open faa $!";
	my $gene;
#	my ($famid) = $file =~ /\.\.(\S+)\.faa/;
	while(<IN>)
	{
		chomp;
		if(s/>//)
		{
			$gene = (/^(\S+)\s/) ? $1 : $_;
#			$hash{$gene} = $famid;
		}
		else
		{
			$seq{$gene} .= $_;
		}
	}
	close IN;
}

if(1==0)
{
my @list=`ls $dir/nuc/*ffn`;
#my %hash_nuc; #indexed with gene name, pointed to famid;
my %seq_nuc;
foreach my $file (@list)
{
	open IN,"$file" || die "can't open faa $!";
	my $gene;
#	my ($famid) = $file =~ /\.\.(\S+)\.fna/;
	while(<IN>)
	{
		chomp;
		if(s/>//)
		{
			$gene = (/^(\S+)\s/) ? $1 : $_;
#			$hash_nuc{$gene} = $famid;
		}
		else
		{
			$seq_nuc{$gene} .= $_;
		}
	}
	close IN;
}
}
##2. generate faa/fna file for each selected scp family
#open IN, "$ortho_re";
open IN, "$ortho_re/selected_scp_famliy_75presence.txt";
<IN>;
while(<IN>)
{
	chomp;
	my @genes = split("\t");
	my $famid = shift @genes;
        open OUT, ">$dir/core_genes/$famid.faa";
 #       open OUT1, ">$dir/core_genes/$famid.dna";
	foreach my $gene(@genes)
	{
	    if($gene eq ""){next}
            if(exists $seq{$gene})
	    { print OUT ">".$gene."\n".$seq{$gene}."\n";}
	    else
	    { print $gene."\n";}
 #           print OUT1 ">".$gene."\n".$seq_nuc{$gene}."\n";
	}
	close OUT;
#	close OUT1;
}
close IN;
