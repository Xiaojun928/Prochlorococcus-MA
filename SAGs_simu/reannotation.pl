#!/usr/bin/perl

use File::Basename;
#re-annot

$dir = $ARGV[0];
`mkdir $dir/reannotation`;
#@files = `ls $dir/genome/*fasta`;
@files = `cat $dir/max_MC`;
foreach $ID (@files) {
	chomp $ID;
#	unless ($file=~/G\S+\.fasta/) { next; }
#	my ($ID) = $file =~ /(G\S+)\.fna\.round.*fasta/;
	`mkdir $dir/reannotation/$ID`;
	#re annot here
	$script = "$dir/reannotation/$ID/$ID.sh";
	open OUT, ">$script";
	print OUT "#!/bin/bash\n";
	print OUT "#SBATCH -n 1\n\n";
	
	`cp $dir/$ID.*fasta $dir/reannotation/$ID/`;
	#print OUT "prokka --fast --noanno --addgenes --locustag $ID --metagenome --cpus 1 --force --prefix $ID --outdir ./  $ID.*fasta\n";
	print OUT "prokka --fast --noanno --addgenes --locustag $ID --metagenome --cpus 1 --force --prefix $ID --outdir $dir/reannotation/$ID $dir/reannotation/$ID/$ID.*fasta\n";
	`chmod +x $script`;
	`sbatch $script`;
}

