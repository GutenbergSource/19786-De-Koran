# checkRef.pl -- check references in TEI tagged files
#
# 1. sequence of numbers
# 2. average size of pages (to determine large deviations)
#
# This tool can be used to discover potential errors in the page numbering
# tags.

use Roman;	# Roman.pm version 1.1 by OZAWA Sakuro <ozawa@aisoft.co.jp>

$inputFile = $ARGV[0];
$previousPage = 0;
$currentPage = 0;
$previousPageText = "?";
$currentPageText = "?";
$currentPageSize = 0;
$totalPageSize = 0;
$numberOfPages = 1;

open(INPUTFILE, $inputFile) || die("Could not open $inputFile");

print "Verifying $inputFile\n";

while (<INPUTFILE>)
{
    $line = $_;
    $remainder = $line;
    while($remainder =~ m/<ref\b(.*?)>/)
    {
	$attrs = $1;
      $remainder = $';
	$target = getAttrVal("target", $attrs);
	$id = getAttrVal("id", $attrs);
	print "ref target=\"$target\" id=\"$id\"\n";

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
