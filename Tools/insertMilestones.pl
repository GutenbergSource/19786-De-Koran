# insertMilestones.pl -- Insert milestones and cross references in a TEI file.

use Roman;	# Roman.pm version 1.1 by OZAWA Sakuro <ozawa@aisoft.co.jp>

$inputFile = $ARGV[0];


open(INPUTFILE, $inputFile) || die("Could not open $inputFile");


$chapterNumber = 0;
$previousVerseNumber = 0;

while (<INPUTFILE>)
{
    $line = $_;

	# recognize chapter number
    if ($line =~ m/<div1\b(.*?)>/)
    {
		$attrs = $1;
		$chapterNumber = getAttrVal("n", $attrs);
		$chapterId = getAttrVal("id", $attrs);
		if (isroman($chapterNumber)) 
		{
			$chapterNumber =  arabic($chapterNumber);
		}
		$previousVerseNumber = 0;
		print STDERR "NOTE: processing chapter $chapterNumber\n";
	}

	handleLine($line);
}



sub handleLine 
{
	my $line = shift;
    my $remainder = $line;

	# Skip over tags.
    while ($remainder =~ m/<(\/?)([a-z0-9]+)\b(.*?)>/)
	{
		my $before = $`;
		my $tag = $&;
		my $closer = $1;
		my $tagname = $2;
		my $attrs = $3;
		$remainder = $';

		# print "Tag: $tag\n";

		handleText($before);
		printText($tag);

		if ($tagname eq "note" && $closer eq "") 
		{
			$remainder = skipNote($remainder);
		}
	}

	handleText($remainder);
}



sub skipNote()
{
	my $fragment = shift;

	while ($fragment !~ m/<\/note>/) 
	{
		$fragment .= <INPUTFILE>;
	}

	my $remainder = "";
	if ($fragment =~ m/<\/note>/) 
	{
		my $before = $`;
		$remainder = $';
		printText($before . "</note>");
	}
	else
	{
		print STDERR "ERROR: unclosed <note>\n";
	}
	return $remainder;
}

# handleText
#
# Handle a stretch of text without any intervening tags. Here we tag all numbers we find as milestones.
#
sub handleText
{
	my $remainder = shift;

	# print "Text: $remainder\n";

    while ($remainder =~ m/([0-9]+)/)
	{
		my $before = $`;
		my $verseNumber = $1;
		$remainder = $';

		# print "Verse: $verseNumber\n";

		printText($before);

		if ($remainder =~ m/^ verzen/) 
		{
			printText($verseNumber);
		}
		else
		{
			if ($verseNumber != $previousVerseNumber + 1) 
			{
				print STDERR "WARNING: versenumbers not in sequence in chapter $chapterNumber, verse $verseNumber follows verse $previousVerseNumber\n";
				print "***";
			}

			printMilestone($chapterNumber, $verseNumber);
			$previousVerseNumber = $verseNumber;
		}
	}
	printText($remainder);
}


sub printText
{
	my $text = shift;
	print $text;
}

sub printMilestone
{
	my $chapter = shift;
	my $verse = shift;

	print "<milestone unit=verse id=s$chapter.$verse n=$verse>$verse";
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
