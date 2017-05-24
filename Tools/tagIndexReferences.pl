# tagIndexReferences.pl


use Roman;	# Roman.pm version 1.1 by OZAWA Sakuro <ozawa@aisoft.co.jp>

$inputFile = $ARGV[0];


open(INPUTFILE, $inputFile) || die("Could not open $inputFile");

# Test
#  II, 23; IX, 12, 23.
#  II, 23, IX, 12, 23.
#  II, 23, IX, 12-23, 45&ndash;67
#  III, IV, 123.



while (<INPUTFILE>)
{
    $line = $_;

	$remainder = $line;
	$result = "";
	while ($remainder =~ m/<ref\b(.*?)>(.*?)<\/ref>/) 
	{
		$before = $`;
		$ref = $&;
		$remainder = $';

		$result .= tagFragment($before) . $ref;
	}
	$result .= tagFragment($remainder);

	print $result;
}


sub tagFragment
{
	my $remainder = shift;
	my $result = "";

	# print "Fragment: $remainder";

	while ($remainder =~ /(\b[IVXLC]+\b)(([,]?) ([0-9]+))?/)
	{
		my $before = $`;
		my $chapterNumber = $1;
		my $verseIndicator = $2;
		my $separator = $3;
		my $verseNumber = $4;
		$remainder = $';

		my $chapterRef = arabic($chapterNumber);

		$result .= $before;

		if ($verseIndicator eq "")
		{
			# we just have a chapter reference.
			$result .= "<ref target=s$chapterRef>$chapterNumber</ref>";
		}
		else
		{
			# we have a chapter and verse reference 
			$result .= "<ref target=s$chapterRef>$chapterNumber</ref>$separator <ref target=s$chapterRef.$verseNumber>$verseNumber</ref>";

			# maybe we have more verse references for this chapter?
			while ($remainder =~ /^([;,] |\&ndash;|-)([0-9]+)/)
			{
				$separator = $1;
				$verseNumber = $2;
				$remainder = $';

				$result .= "$separator<ref target=s$chapterRef.$verseNumber>$verseNumber</ref>";
			}
		}
	}

	return $result . $remainder;
}