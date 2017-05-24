<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<!-- extractKoran.pl - extract text of Koran from annotated version -->

<xsl:template match="TEI.2">
	<TEI.2>
		<xsl:apply-templates select="@*"/>
		<xsl:apply-templates select="teiHeader"/>
		<text>
			<body>
				<xsl:apply-templates select="text/body/div0[@id='pt4']" mode="extract"/>
			</body>
		</text>
	</TEI.2>
</xsl:template>



<xsl:template match="*">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|processing-instruction()|comment()">
	<xsl:copy/>
</xsl:template>

<xsl:template match="text()">
	<xsl:value-of select="."/>
</xsl:template>






<xsl:template match="note" mode="extract">
</xsl:template>

<xsl:template match="*" mode="extract">
	<xsl:copy>
		<xsl:apply-templates select="*|@*|processing-instruction()|comment()|text()" mode="extract"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="@*|processing-instruction()|comment()" mode="extract">
	<xsl:copy/>
</xsl:template>

<xsl:template match="text()" mode="extract">
	<xsl:value-of select="."/>
</xsl:template>



</xsl:stylesheet>
