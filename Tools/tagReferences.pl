# tagReferences.pl


use Roman;	# Roman.pm version 1.1 by OZAWA Sakuro <ozawa@aisoft.co.jp>

$inputFile = $ARGV[0];


open(INPUTFILE, $inputFile) || die("Could not open $inputFile");


while (<INPUTFILE>)
{
    $line = $_;

	$line = tagVerseRef($line);

	$remainder = $line;
	$result = "";
	while ($remainder =~ m/<ref\b(.*?)>(.*?)<\/ref>/) 
	{
		$before = $`;
		$ref = $&;
		$remainder = $';

		$result .= tagChapterRef($before) . $ref;
	}
	$result .= tagChapterRef($remainder);
	$line = $result;


	$remainder = $line;
	$result = "";
	while ($remainder =~ m/<ref\b(.*?)>(.*?)<\/ref>/) 
	{
		$before = $`;
		$ref = $&;
		$remainder = $';

		$result .= tagChapterRef2($before) . $ref;
	}
	$result .= tagChapterRef2($remainder);
	$line = $result;


	$remainder = $line;
	$result = "";
	while ($remainder =~ m/<ref\b(.*?)>(.*?)<\/ref>/) 
	{
		$before = $`;
		$ref = $&;
		$remainder = $';

		$result .= tagPageRef($before) . $ref;
	}
	$result .= tagPageRef($remainder);
	$line = $result;


	print $line;
}


# tag references to pages.
sub tagPageRef
{
	my $remainder = shift;
	my $result = "";

	# tag full references to verses
	while ($remainder =~ m/([Bb]ladzijde|[Bb]lz\.|[Bb]ladz\.) ([IVXLC]+|[0-9]+)/) 
	{
		$before = $`;
		$remainder = $';

		$pageName = $1;
		$pageNumber = $2;

		$tag = "$pageName <ref target=pb$pageNumber type=pageref>$pageNumber</ref>";
		# print "$tag\n";

		$result .= $before . $tag;
	}
	$result .= $remainder;
	return $result;
}


# tag references to just chapters (number before chapter with ordinal indicator)
sub tagChapterRef2
{
	my $remainder = shift;
	my $result = "";

	# tag full references to verses
	while ($remainder =~ m/([IVXLC]+|[0-9]+)(e) ([Ss]oera|[Hh]oofdst(uk|\.))/) 
	{
		$before = $`;
		$remainder = $';

		$chapterName = $3;
		$ordinal = $2;
		$chapterNumber = $1;
		$chapterRef = isroman($chapterNumber) ? arabic($chapterNumber) : $chapterNumber;

		$tag = "<ref target=s$chapterRef>$chapterNumber$ordinal $chapterName</ref>";
		# print "$tag\n";

		$result .= $before . $tag;
	}
	$result .= $remainder;
	return $result;
}


# tag references to just chapters
sub tagChapterRef
{
	my $remainder = shift;
	my $result = "";

	# tag full references to verses
	while ($remainder =~ m/([Ss]oera|[Hh]oofdst(uk|\.)) ([IVXLC]+|[0-9]+)/) 
	{
		$before = $`;
		$remainder = $';

		$chapterName = $1;
		$chapterNumber = $3;
		$chapterRef = isroman($chapterNumber) ? arabic($chapterNumber) : $chapterNumber;

		$tag = "<ref target=s$chapterRef>$chapterName $chapterNumber</ref>";
		# print "$tag\n";

		$result .= $before . $tag;
	}
	$result .= $remainder;
	return $result;
}



# tag references to chapters and verses.
sub tagVerseRef
{
	my $remainder = shift;
	my $result = "";

	# tag full references to verses
	while ($remainder =~ m/([Ss]oera|[Hh]oofdst(uk|\.)) ([IVXLC]+|[0-9]+)([:.,]?) (v(ers|s?\.)) ([0-9]+)/) 
	{
		$before = $`;
		$remainder = $';

		$chapterName = $1;
		$chapterNumber = $3;
		$separator = $4;
		$verseName = $5;
		$verseNumber = $7;
		$chapterRef = isroman($chapterNumber) ? arabic($chapterNumber) : $chapterNumber;

		$tag = "<ref target=s$chapterRef.$verseNumber>$chapterName $chapterNumber$separator $verseName $verseNumber</ref>";
		# print "$tag\n";

		$result .= $before . $tag;
	}
	$result .= $remainder;
	return $result;
}





# Test: 
# Hoofdstuk X vers 93.
# Hoofdstuk X v. 93.
# Hoofdst. X v. 93.
# Hoofdstuk X, v. 93.
# Hoofdst. X, v. 93.
# Hoofdstuk 23.
# Hoofdstuk XLIII.
# XXVe Hoofdstuk
# 13e Hoofdstuk
# bladzijde 23.
# blz. 123
# bladz. 623.