<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:guid="urn:x-lexisnexis:content:guid:global:1"
    xmlns:legis="urn:x-lexisnexis:content:legislation:mastering:1"
    xmlns:base="urn:x-lexisnexis:content:default:mastering:1"
    xmlns:primlaw="urn:x-lexisnexis:content:primarylaw:mastering:1"
    xmlns:form="urn:x-lexisnexis:content:form:mastering:1"
    xmlns:note="urn:x-lexisnexis:content:notes:mastering:1"
    xmlns:jurisinfo="urn:x-lexisnexis:content:jurisdiction-info:mastering:1"
    xmlns:legisbr="urn:x-lexisnexis:content:legislativebranch:mastering:1"
    xmlns:doc="urn:x-lexisnexis:content:documentlevelmetadata:mastering:1"
    xmlns:cfi="http://www.lexisnexis.com/xmlschemas/content/shared/cite-finding-information/1/"
    xmlns:lnci="http://www.lexisnexis.com/xmlschemas/content/shared/citations/1/"
    xmlns:globalentity="urn:x-lexisnexis:content:identified-entities:global:1"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:meta="urn:x-lexisnexis:content:metadata:mastering:1"
    xmlns:ref="urn:x-lexisnexis:content:reference:mastering:1"
    xmlns:lntbl="urn:x-lexisnexis:content:default:lexisnexis-table-extensions:mastering:1"
    xmlns:mncrdocmeta="urn:x-lexisnexis:content:mncrdocmeta:mastering:1"
    xmlns:primlawhist="urn:x-lexisnexis:content:primarylaw-history:mastering:1"
    xmlns:legishist="urn:x-lexisnexis:content:legislation-history:mastering:1"
    xmlns:toc="urn:x-lexisnexis:content:toc:mastering:1"
    xmlns:courtrule="urn:x-lexisnexis:content:courtrule:mastering:1"
    xml:id="VIC_ACTS_9714-22"
    guid:guid="urn:contentItem:"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes" use-character-maps="html-illegal-chars"/>
    <xsl:character-map name="html-illegal-chars">
        <xsl:output-character character="&#xa0;" string=" "/>
        <xsl:output-character character="Â" string=" "/>
    </xsl:character-map>
    
    <!--<xsl:preserve-space elements="p span a"/>-->
    <xsl:strip-space elements="p"/>
    
    <xsl:template match="/">
        <!--<root>
            <xsl:apply-templates/>
        </root>-->
        <xsl:variable name="fullcontent">
            <root>
                <xsl:apply-templates/>
            </root>
        </xsl:variable>
        <xsl:apply-templates select="$fullcontent" mode="finalCleanup"/>
    </xsl:template>
    
    <xsl:template match="p" mode="finalCleanup">
        <xsl:for-each-group select="node()" group-adjacent="exists(self::p)">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:text>&#10;</xsl:text><p><xsl:apply-templates select="current-group()"/>
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text><p><xsl:text/><xsl:value-of select="replace(current-group(), '\s+', ' ')"/>
                        <!--<xsl:apply-templates select="current-group()"/>-->
                        <!--<xsl:value-of select="current-group()"/>-->
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template match="p[@class=('AmendHeading-PART','Heading-PART')]">
        <xsl:variable name="temp">
            <xsl:apply-templates/>
        </xsl:variable>
        <p><xsl:text/>
            <xsl:value-of select="upper-case($temp)"/>
        </p><!--<xsl:text>&#10;</xsl:text>-->
    </xsl:template>
    
    <xsl:template match="p">
        <xsl:for-each-group select="node()" group-adjacent="exists(self::base:list|self::base:table|
self::base:quote|self::note:marginNote|self::base:comment|self::a[@href!=''][span[contains(@class,'EndnoteReference')]][not(ancestor::p[@class='EndnoteText'])])">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="blankcheck">
                        <xsl:with-param name="currentNode" select="current-group()"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
        
    </xsl:template>
    
    <xsl:template match="legis:shortTitle|base:designator|base:title|base:listItemEnumerator|dc:identifier|dc:date">
        <!--<xsl:text>&#10;</xsl:text>--><p><xsl:text/>
            <xsl:value-of select="replace(., '\s+', ' ')"/>
        </p>
    </xsl:template>
    
    <xsl:template match="base:entry">
        <xsl:if test="preceding-sibling::base:entry">
            <xsl:text>  </xsl:text>
        </xsl:if>
            <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="br">
        <xsl:text> </xsl:text>
    </xsl:template>
    
    <xsl:template match="*" priority="-11">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="@* | node()" mode="finalCleanup">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()" mode="finalCleanup"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" priority="-11" mode="finalCleanup">
        <!--<xsl:value-of select="replace(replace(.,'&#10;', ''), '  ', ' ')"/>-->
        <xsl:value-of select="replace(replace(replace(.,'&#10;', ''), '\s+', ' '),'  +',' ')"/>
    </xsl:template>
    <!--[contains(.,'&#xa0;&#xa0;')]-->
    <xsl:template match="span">
        <xsl:value-of select="replace(replace(.,'&#xa0;+', ' '),'  +',' ')"/>
    </xsl:template>

    <xsl:template name="blankcheck">
        <xsl:param name="currentNode" required="yes"/>
        <xsl:variable name="temp">
            <xsl:value-of select="$currentNode"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space(replace($temp,'_',''))=''"/>
            <xsl:when test="normalize-space($temp) != '&#xa0;'">
                <!--<xsl:text>&#10;</xsl:text>--><p><xsl:text/>
                    <!--<xsl:value-of select="replace($currentNode, '\s+', ' ')"/>-->
                    <xsl:apply-templates select="$currentNode"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$currentNode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Footnote reference -->
    <xsl:template match="a[@href!=''][span[contains(@class,'EndnoteReference')]][not(ancestor::p[@class='EndnoteText'])]">
        <xsl:variable name="hrefn" select="replace(@href,'#','')"/>
        <xsl:apply-templates select="//div[@id=$hrefn]" mode="footnote"/>
    </xsl:template>
    
    <!-- Footnote reference -->
    <xsl:template match="div[@id!=''][p[@class='EndnoteText']]" mode="footnote">
        <xsl:apply-templates/>
    </xsl:template>
    
    <!-- Node dropped -->
    <xsl:template match="head|p[@class=('TOC1','TOC2','TOC3','TOC4','TOC5','TOC6','TOC7','TOC8','TOC9','Stars')]|
        body/*[1][self::div[p[@class='Title']]]"/>
    
    <xsl:template match="div[@id!=''][p[@class='EndnoteText']]"/>
    
    
    <!--<xsl:template match="p[a[@name=('tpActTitle','tpVersion1','tpActNo','tpSectionClause')]]"/>-->

    <xsl:template match="p/*[1][self::span][normalize-space(.)='&#xa0;'] |
        p/a/*[1][self::span][normalize-space(.)='&#xa0;']"/>
    
</xsl:stylesheet>
