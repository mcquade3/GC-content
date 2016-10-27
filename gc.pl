# Mike McQuade
# gc.pl
# Calculates the GC-content of given DNA strings,
# then returns the ID of the string followed by
# the GC-content of the string.

use strict;
use warnings;

# Open the text file containing the DNA strands
my $filename = "gc.txt";
open(my $fh, '<', $filename) or die "Can't open $filename: $!";

# Initialize the global variables
my ($greatestID,$greatestRatio,$tempID,$tempRatio,$count,$total);
$tempID = "";
$greatestRatio = $tempRatio = $count = 0;
$total = 1;

# Read the file one line at a time
while (my $line = <$fh>) {
	if ($line =~ /^>/) { # Detects a new FASTA ID
		calcRatio(); # Calculates the ratio for the previous strand
		$tempID = substr($line,1); # Stores the name of the new strand in a temporary variable
		$count = $total = 0; # Resets the count and total variables for the new strand
	} else { # Detects the string for the DNA strand
		foreach my $letter (split //, $line) { # Reads each individual letter in the DNA strand
			if ($letter eq 'G' || $letter eq 'C') {$count++;} # Counts how many G's and C's are in the strand
			if ($letter =~ /[^\s]/) {$total++;} # Counts how many total letters are in the strand
		}
	}
}
calcRatio(); # Calculates the ratio for the last strand in the file

# Close the file reader
close $fh;

# Print out the greatest ratio along with the ID of the strand of the greatest ratio
print $greatestID;
printf("%.6f",$greatestRatio);
print "\n";

# Calculates the ratio of the current FASTA string using the global variables
sub calcRatio {
	$tempRatio = $count/$total * 100; # Stores the value of the current strand's ratio in a temporary variable
	if ($tempRatio > $greatestRatio) { # Checks to see if the calculated ratio is greater than the previous champion
		# If the calculated ratio is greater than the previous greatest ratio,
		# the ID and value are assigned to the greatest variables
		$greatestID = $tempID;
		$greatestRatio = $tempRatio;
	}
}