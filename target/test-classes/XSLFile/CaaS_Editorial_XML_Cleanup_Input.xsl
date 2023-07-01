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

    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <!--<xsl:preserve-space elements="p span a"/>-->
    <xsl:strip-space elements="row entry text para"/>
    
    <xsl:variable name="metafile" select="concat(replace(substring-before(document-uri(.), tokenize(document-uri(.), '/')[last()]), '%20', ' '), 'meta.xml')"/> 
    
    <xsl:variable name="metadata">
        <xsl:copy-of select="document($metafile)/legmetadata"/>
    </xsl:variable>
    
    <xsl:template match="/">
        <root>
            <xsl:apply-templates/>
        </root>
        <!--<xsl:variable name="fullcontent">
            <root>
                <xsl:apply-templates/>
            </root>
        </xsl:variable>-->
        <!--<xsl:apply-templates select="$fullcontent" mode="finalCleanup"/>-->
    </xsl:template>
    
    <xsl:template match="p" mode="finalCleanup">
        <xsl:for-each-group select="node()" group-adjacent="exists(self::p)">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <!--<xsl:text>&#10;</xsl:text><p>-->
                        <xsl:apply-templates select=" current-group()"/>
                    <!--</p>-->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text><p>
                        <xsl:apply-templates select=" current-group()"/>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="no" mode="number">
        <xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="text">
        <xsl:choose>
            <xsl:when test="parent::title">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each-group select="node()" group-adjacent="exists(self::list|self::table|
                    self::quote|self::note:marginNote|self::comment|self::definitionList|self::object)">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="currentgrp">
                                <xsl:value-of select="current-group()"/>
                            </xsl:variable>
                            <xsl:if test="normalize-space($currentgrp)!=''">
                                <xsl:text>&#10;</xsl:text><p>
                                    <xsl:if test="(current-group()/parent::text/parent::para/preceding-sibling::*[1][self::no] or 
                                        current-group()/preceding-sibling::*[1][self::no]) and not(current-group()/parent::text/preceding-sibling::text)">
                                        <xsl:apply-templates select="current-group()/parent::text/parent::para/preceding-sibling::*[1][self::no]|
                                            current-group()/preceding-sibling::*[1][self::no]" mode="number"/>
                                    </xsl:if>
                                    <xsl:if test="current-group()/parent::text/parent::para[not(preceding-sibling::*)]/parent::footnote">
                                        <xsl:if test="not(current-group()/parent::text/preceding-sibling::*[1][self::text])">
                                            <xsl:text>[</xsl:text><xsl:value-of select="current-group()/ancestor-or-self::footnote/@char"/><xsl:text>] </xsl:text>
                                        </xsl:if>
                                    </xsl:if>
                                    <xsl:apply-templates select="current-group()"/>
                                </p>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="object">
        <xsl:text>&#10;</xsl:text><p><xsl:value-of select="@checksum"/>
        <xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="title|intref">
        <xsl:text>&#10;</xsl:text><p><xsl:apply-templates/></p>
    </xsl:template>

    <!-- billrec -->
    <xsl:template match="billid|status|assentdate|govbill|house|date|stage|note|cognatebillid">
        <xsl:text>&#10;</xsl:text><p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="billdesc">
        <xsl:if test="$metadata/legmetadata/legtitle!=''">
            <xsl:text>&#10;</xsl:text><p><xsl:value-of select="$metadata/legmetadata/legtitle"/></p>
        </xsl:if>
        <xsl:text>&#10;</xsl:text><p><xsl:apply-templates/></p>
    </xsl:template>
    
    
    <xsl:template match="no">
        <xsl:choose>
            <xsl:when test="parent::li"/>
            <xsl:otherwise>
                <xsl:apply-templates/>
                <xsl:if test="following-sibling::*[1][self::para] or following-sibling::*[1][self::text]">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="notes">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="fnmarker">
        <xsl:apply-templates select="//footnote" mode="footnote"/>
    </xsl:template>
    
    <xsl:template match="footnote">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="@char"/>
    <xsl:text>] </xsl:text>
    </xsl:template>

    <xsl:template match="footnote" mode="footnote">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="entry">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="level">
        <xsl:apply-templates select="title,subtitle,intref"/>
        <xsl:apply-templates select="* except (title|subtitle|intref)"/>
    </xsl:template>
    
    <xsl:template match="*" priority="-11">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" priority="-11">
        <xsl:value-of select="replace(replace(.,'&#10;', ''), '  ', ' ')"/>
    </xsl:template>
    
    <xsl:template name="blankcheck">
        <xsl:param name="currentNode" required="yes"/>
        <xsl:variable name="temp">
            <xsl:value-of select="$currentNode"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space(replace($temp,'_',''))=''"/>
            <xsl:when test="normalize-space($temp) != '&#xa0;'">
                <xsl:text>&#10;</xsl:text><p>
                    <xsl:apply-templates select="$currentNode"/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$currentNode"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Node dropped -->

</xsl:stylesheet>
