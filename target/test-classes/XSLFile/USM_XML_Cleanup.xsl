<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lnvxe="http://www.lexis-nexis.com/lnvxe" xmlns:lnv="http://www.lexis-nexis.com/lnv" xmlns:lnvni="http://www.lexis-nexis.com/lnvni"
    xmlns:lnclx="http://www.lexis-nexis.com/lnclx" xmlns:lncle="http://www.lexis-nexis.com/lncle" xmlns:lndel="http://www.lexis-nexis.com/lndel"
    xmlns:lngntxt="http://www.lexis-nexis.com/lngntxt" xmlns:lndocmeta="http://www.lexis-nexis.com/lndocmeta" xmlns:lnlit="http://www.lexis-nexis.com/lnlit"
    xmlns:lnci="http://www.lexis-nexis.com/lnci" xmlns:nitf="urn:nitf:iptc.org.20010418.NITF" xmlns:lnvx="http://www.lexis-nexis.com/lnvx"
    xmlns:ci="http://www.lexis-nexis.com/ci" xmlns:glp="http://www.lexis-nexis.com/glp" xmlns:case="http://www.lexis-nexis.com/glp/case"
    xmlns:jrnl="http://www.lexis-nexis.com/glp/jrnl" xmlns:comm="http://www.lexis-nexis.com/glp/comm" xmlns:cttr="http://www.lexis-nexis.com/glp/cttr"
    xmlns:dict="http://www.lexis-nexis.com/glp/dict" xmlns:dig="http://www.lexis-nexis.com/glp/dig" xmlns:docinfo="http://www.lexis-nexis.com/glp/docinfo"
    xmlns:frm="http://www.lexis-nexis.com/glp/frm" xmlns:in="http://www.lexis-nexis.com/glp/in" xmlns:leg="http://www.lexis-nexis.com/glp/leg"
    xmlns:xhtml="http://www.w3c.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:preserve-space elements="ci:cite emph"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="LEGDOC">
        <root>
            <xsl:apply-templates/>
        </root>
    </xsl:template>
    
    <xsl:template match="text|desig|title|lilabel|row">
        <xsl:text>&#10;</xsl:text><p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="person">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::text">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#10;</xsl:text><p><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="entry">
        <xsl:if test="preceding-sibling::entry">
            <xsl:text>  </xsl:text>
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>
    
    <!--<xsl:template match="ci:cite">
        <xsl:text/><xsl:apply-templates/><xsl:text/>
    </xsl:template>-->
    
    <xsl:template match="*" priority="-11">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" priority="-11">
        <xsl:value-of select="replace(replace(.,'&#10;', ''), '  ', ' ')"/>
    </xsl:template>
    
    <xsl:template match="leg:info|docinfo"/>
    
</xsl:stylesheet>
