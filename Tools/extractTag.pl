# extractTag.pl -- extract texts within a certain tag from a TEI file.
#

$inputFile = $ARGV[0];
$searchTag = $ARGV[1];


open(INPUTFILE, $inputFile) || die("Could not open $inputFile");

while (<INPUTFILE>)
{
    $line = $_;
    $remainder = $line;
    while ($remainder =~ m/<$searchTag\b(.*?)>(.*?)<\/$searchTag>/)
    {
		$attrs = $2;
		$content = $2;
		$remainder = $';

		print "$content\n";
    }
}

# Get an attribute value (if the attribute is present)
sub getAttrVal
{
	my $attrName = shift;
	my $attrs = shift;
	my $attrVal = "";

	if($attrs =~ /$attrName\s*=\s*(\w+)/i)
	{
		$attrVal = $1;
	}
	elsif($attrs =~ /$attrName\s*=\s*\"(.*?)\"/i)
	{
		$attrVal = $1;
	}
	return $attrVal;
}
