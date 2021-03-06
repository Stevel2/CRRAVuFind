<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xlink="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:output method="xml" indent="yes" encoding="utf-8"/>

    <xsl:param name="institution">My University</xsl:param>
    <xsl:param name="building">My Library</xsl:param>
    <xsl:param name="idprefix">ead_</xsl:param>
    <xsl:param name="htmlroot">/findingaids/</xsl:param>
    
    <xsl:template match="ead">
        <add>
            <doc>
				<!-- identifier use one in file or generate random -->
				<field name="id">
					<xsl:choose>
						<xsl:when test="(string-length(./eadheader/eadid) > 0 and not(contains(./eadheader/eadid, 'http')) and not(contains(./eadheader/eadid, 'sample')))">
							<xsl:value-of select="$idprefix"/><xsl:value-of select="translate(./eadheader/eadid,' ','_')"/>
						</xsl:when>	
						<xsl:when test="(string-length(./archdesc/did/unitid/@id) > 0)">
							<xsl:value-of select="$idprefix"/><xsl:value-of select="(./archdesc/did/unitid/@id)"/>
						</xsl:when>	
						<xsl:otherwise>								
							<xsl:value-of select="$idprefix"/><xsl:value-of select="format-dateTime(current-dateTime(),'[Y0001][M01][D01][H01][m01][s][f]')"/>
						</xsl:otherwise>
					</xsl:choose>
				</field>

                <!-- ALLFIELDS -->
                <field name="allfields">
                    <xsl:value-of select="normalize-space(.)"/>
                </field>

				<!-- institution -->
				<field name="institution">
					<xsl:value-of select="$institution" />
				</field>

				<!-- building -->
				<field name="building">
					<xsl:value-of select="$building" />
				</field>
				
                <!-- RECORD FORMAT -->
                <field name="record_format">index</field>				

				<!-- title -->
				<field name="title">
					<xsl:value-of select="normalize-space(./eadheader/filedesc/titlestmt/titleproper)"/>
					<xsl:for-each select="./eadheader/filedesc/titlestmt/subtitle">
						<xsl:if test="(string-length() > 0)">
							<xsl:text disable-output-escaping="yes"> : </xsl:text><xsl:value-of select="(.)"/>
						</xsl:if>
					</xsl:for-each>
				</field>
				<field name="title_short">
					<xsl:value-of select="normalize-space(./eadheader/filedesc/titlestmt/titleproper)"/>
				</field>
				<field name="title_full">
					<xsl:value-of select="normalize-space(./eadheader/filedesc/titlestmt/titleproper)"/>
				</field>
				
				<field name="title_sort">
					<xsl:call-template name="RemoveLeadingArticles">
						<xsl:with-param name="TextToReplace" select="string(./eadheader/filedesc/titlestmt/titleproper)"/>
					</xsl:call-template>
				</field>
			
				<!-- dates -->
				<field name="publishDate">
					<xsl:value-of select="normalize-space(./archdesc/did/unitdate)"/>
				</field>

				<!-- publisher -->
				<field name="publisher">
					<xsl:value-of select="normalize-space(./eadheader/filedesc/publicationstmt/publisher)"/>
				</field>

                <!-- format -->
                <field name="format">Archival Material</field>				

                <!-- physical / extent -->
				<field name="physical">
					<xsl:value-of select="normalize-space(./archdesc/did/physdesc)"/>
				</field>

                <!-- language -->
				<field name="language">
					<xsl:value-of select="normalize-space(./eadheader/profiledesc/langusage/language)"/>
				</field>

                <!-- subjects -->
				<xsl:for-each select="./archdesc/controlaccess/subject">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>
				<xsl:for-each select="./archdesc/controlaccess/persname">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>
				<xsl:for-each select="./archdesc/controlaccess/corpname">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>
				<xsl:for-each select="./archdesc/controlaccess/controlaccess/subject">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>
				<xsl:for-each select="./archdesc/controlaccess/controlaccess/persname">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>
				<xsl:for-each select="./archdesc/controlaccess/controlaccess/corpname">
					<field name="topic">
						<xsl:value-of select="normalize-space(.)"/>
					</field>
				</xsl:for-each>

                <!-- abstract -->
				<field name="description">
					<xsl:value-of select="normalize-space(./archdesc/did/abstract)"/>
				</field>				

                <!-- finding aid urls -->
				<field name="remotefindingaidurl_str_mv">
					<xsl:value-of select="normalize-space(./eadheader/eadid/@url)"/>
				</field>				

            </doc>
        </add>
    </xsl:template>

	<!-- Template to remove leading articles from title for title_sort  -->
	<xsl:template name="RemoveLeadingArticles">
		<xsl:param name="TextToReplace"></xsl:param>
		<xsl:choose>
			<xsl:when test="(substring($TextToReplace,1,2)='A ')">
				<xsl:value-of select="substring($TextToReplace,3)"/>
			</xsl:when>	
			<xsl:when test="(substring($TextToReplace,1,3)='An ')">
				<xsl:value-of select="substring($TextToReplace,4)"/>
			</xsl:when>	
			<xsl:when test="(substring($TextToReplace,1,4)='The ')">
				<xsl:value-of select="substring($TextToReplace,5)"/>
			</xsl:when>	
			<xsl:otherwise>
				<xsl:value-of select="$TextToReplace"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>


