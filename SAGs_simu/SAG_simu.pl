$LENDIST = "length_distribution.txt";
$COMDIST = "completeness_distribution.txt";
$GNMLIST = "genome_list.txt";
$MUTRATE = 15 / 100000;
$ROUND   = 10;
$MINFLEN = 100;

#read the distribution of SAG contig length
open IN, $LENDIST;
while (<IN>) { chomp; push @LENDIST, $_; }
close IN;

#read the distribution of SAG completeness
open IN, $COMDIST;
while (<IN>) { chomp; push @COMDIST, $_; }
close IN;

#open genome list file or traverse current folder
unless (-e $GNMLIST) { `ls *fasta > $GNMLIST`; }
open FH, $GNMLIST;
while (<FH>) {
	#for each genome
	chomp ($genome = $_);
	
	#transfer genome file into two-line id-seq fasta format
	open IN, "../$genome";
	open OUT, ">$genome.oneline";
	while (<IN>) { print OUT; last; }
	while (<IN>) {
		chomp;
		if (/>/) { print OUT "\n$_\n"; }
		else { print OUT; }
	}
	print OUT "\n";
	close IN;
	close OUT;
	
	#calculate total length
	open IN, "$genome.oneline";
	$genome_length = 0;
	while (<IN>) { chomp; unless (/>/) { $genome_length += length; }}
	close IN;
	
	#create a SAG completeness summary
	open SUM, ">$genome.txt";
	
	################
	#foreach round, use different completeness, assemble error sites, and fragment division
	################
	for ($round=1; $round<=$ROUND; $round++) {		
		#calculate estimated length (total-length x completeness)
		$expected_completeness = int(rand(@COMDIST));
		$expected_completeness = $COMDIST[$expected_completeness];
		$expected_length = $genome_length * $expected_completeness / 100;
		
		#print to SAG completeness summary
		print SUM "round$round\t$expected_completeness\n";
		
		#SAG assemble error at random site
		open IN, "$genome.oneline";
		open OUT, ">$genome.round$round.error";
		while (<IN>) {
			if (/>/) { print OUT; next; }
			chomp ($sequence = $_);
			@site = split "", $sequence;
			foreach $site (@site) {
				if ($site eq 'N') { next; }
				$exist_error = rand();
				#good assemble site
				if ($exist_error > $MUTRATE) { print OUT $site; }
				#bad assemble site
				else {
					%atgc = ('A',1,'T',1,'C',1,'G',1);
					foreach $bad_site (keys %atgc) { if ($bad_site eq $site){ delete $atgc{$site}; }}
					foreach $bad_site (keys %atgc) { print OUT $bad_site; last; }
				}
			}
			print  OUT "\n";
		}
		close IN;
		close OUT;
				
		#for each contig
		#split it into fragments using sliding window method
		open IN, "$genome.round$round.error";
		$fragment_id = 0;
		chomp ($contig = <IN>);
		while ($contig ne "") {
			if ($contig =~ />/) { chomp ($contig = <IN>); next; }
			$contig_length = length $contig;
			#get a random length from SAG length distribution
			$expected_fragment_length1 = int(rand(@LENDIST));
			$expected_fragment_length1 = $LENDIST[$expected_fragment_length1];
			$expected_fragment_length2 = int(rand(@LENDIST));
			$expected_fragment_length2 = $LENDIST[$expected_fragment_length2];
			#split this contig into two fragments if contig length is larger than len1+len2
			if ($contig_length > $expected_fragment_length1 + $expected_fragment_length2) {
				$split_contig1 = substr ($contig, 0, $expected_fragment_length1);
				$split_contig2 = substr ($contig, $expected_fragment_length1);
				$fragment_id++;
				$fragment{$fragment_id} = $split_contig1;
				$contig = $split_contig2;
			}
			#set this contig as one fragment if contig length is smaller than len1+$MINFLEN
			elsif ($contig_length <= $expected_fragment_length1 + $MINFLEN) {
				$fragment_id++;
				$fragment{$fragment_id} = $contig;
				chomp ($contig = <IN>);
			}
			#else there are two random possibilities
			else {
				$zero_or_one = int(rand(2));
				#50% chance to randomly split this contig into two fragments
				if ($zero_or_one) {
					$split_contig1 = substr ($contig, 0, $expected_fragment_length1);
					$split_contig2 = substr ($contig, $expected_fragment_length1);
					$fragment_id++;
					$fragment{$fragment_id} = $split_contig1;
					$fragment_id++;
					$fragment{$fragment_id} = $split_contig2;
					chomp ($contig = <IN>);
				}
				#50% chance to set this contig as one fragment
				else {
					$fragment_id++;
					$fragment{$fragment_id} = $contig;
					chomp ($contig = <IN>);
				}
			}
		}
		close IN;
		`rm $genome.round$round.error`;
		
		#extract fragments (slightly larger than expected length now)
		undef %extracted_fragment;
		$extracted_length = 0;
		while ($extracted_length < $expected_length) {
			foreach $target (keys %fragment) {
				$extracted_fragment{$target} = $fragment{$target};
				$extracted_length += length $fragment{$target};
				delete $fragment{$target};
				last;
			}
		}
		#50% chance to remove the last fragment (won't always larger than expected length!)
		$zero_or_one = int(rand(2));
		if ($zero_or_one) { delete $extracted_fragment{$target}; }
		
		#output
		open OUT, ">$genome.round$round.fasta";
		foreach $fragment_id (sort {$a <=> $b} keys %extracted_fragment) { print OUT ">fragment$fragment_id\n$extracted_fragment{$fragment_id}\n"; }
		close OUT;
	}
	
	#remove temporary file
	`rm $genome.oneline`;
	undef %fragment;
}
