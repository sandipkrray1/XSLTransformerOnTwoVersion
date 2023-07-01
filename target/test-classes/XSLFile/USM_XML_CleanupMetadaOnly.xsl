<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:lnvxe="http://www.lexis-nexis.com/lnvxe" xmlns:lnv="http://www.lexis-nexis.com/lnv" xmlns:lnvni="http://www.lexis-nexis.com/lnvni"
    xmlns:lnclx="http://www.lexis-nexis.com/lnclx" xmlns:lncle="http://www.lexis-nexis.com/lncle" xmlns:lndel="http://www.lexis-nexis.com/lndel"
    xmlns:lngntxt="http://www.lexis-nexis.com/lngntxt" xmlns:lndocmeta="http://www.lexis-nexis.com/lndocmeta" xmlns:lnlit="http://www.lexis-nexis.com/lnlit"
    xmlns:lnci="http://www.lexis-nexis.com/lnci" xmlns:nitf="urn:nitf:iptc.org.20010418.NITF" xmlns:lnvx="http://www.lexis-nexis.com/lnvx"
    xmlns:ci="http://www.lexis-nexis.com/ci" xmlns:glp="http://www.lexis-nexis.com/glp" xmlns:case="http://www.lexis-nexis.com/glp/case"
    xmlns:jrnl="http://www.lexis-nexis.com/glp/jrnl" xmlns:comm="http://www.lexis-nexis.com/glp/comm" xmlns:cttr="http://www.lexis-nexis.com/glp/cttr"
    xmlns:dict="http://www.lexis-nexis.com/glp/dict" xmlns:dig="http://www.lexis-nexis.com/glp/dig"
    xmlns:docinfo="http://www.lexis-nexis.com/glp/docinfo"
    xmlns:frm="http://www.lexis-nexis.com/glp/frm" xmlns:in="http://www.lexis-nexis.com/glp/in" xmlns:leg="http://www.lexis-nexis.com/glp/leg"
    xmlns:xhtml="http://www.w3c.org/1999/xhtml"
    exclude-result-prefixes="#all"
    version="2.0">

    <xsl:output method="xml" indent="no" encoding="UTF-8" omit-xml-declaration="yes" exclude-result-prefixes="#all"/>
    <xsl:preserve-space elements="ci:cite emph"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="LEGDOC">
        <root>
            <xsl:apply-templates select="docinfo|leg:body/leg:info"/>
        </root>
    </xsl:template>
    
    <!-- docinfo -->
    <xsl:template match="docinfo">
        <xsl:text>&#10;</xsl:text><docinfo>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="*">
                <xsl:variable name="tag" select="replace(name(.),':','-')"/>
                <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
                    <xsl:copy-of select="./@*"/>
                    <xsl:apply-templates select="."/>
                </xsl:element>
            </xsl:for-each>
        </docinfo>
    </xsl:template>
    
    <xsl:template match="docinfo:hier">
        <xsl:for-each select="*">
            <xsl:variable name="tag" select="replace(name(.),':','-')"/>
            <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
                <xsl:copy-of select="./@*"/>
                <xsl:apply-templates select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="docinfo:assoc-links|docinfo:custom-metafields|docinfo:hierlev|heading[ancestor::docinfo:hierlev]">
        <xsl:for-each select="*">
            <xsl:variable name="tag" select="replace(name(.),':','-')"/>
            <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
                <xsl:copy-of select="./@*"/>
                <xsl:apply-templates select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="title[ancestor::docinfo:hierlev]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="docinfo:normcite|ci:cite[ancestor::docinfo:normcite]|ci:sesslaw[ancestor::docinfo:normcite]|
        ci:sesslawinfo[ancestor::docinfo:normcite]|ci:jurisinfo[ancestor::docinfo:normcite]|ci:hier[ancestor::docinfo:normcite]|
        ci:hierlev[ancestor::docinfo:normcite]|ci:sesslawref[ancestor::docinfo:normcite]">
        <xsl:for-each select="*">
            <xsl:variable name="tag" select="replace(name(.),':','-')"/>
            <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
                <xsl:copy-of select="./@*"/>
                <xsl:apply-templates select="."/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- leg:info -->    
    <xsl:template match="leg:info">
        <xsl:text>&#10;</xsl:text><leg-info>
            <xsl:copy-of select="@*"/>
            <xsl:for-each select="*">
                <xsl:variable name="tag" select="replace(name(.),':','-')"/>
                <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
                    <xsl:copy-of select="./@*"/>
                    <xsl:apply-templates select="."/>
                </xsl:element>
            </xsl:for-each>
        </leg-info>
    </xsl:template>
    <xsl:template match="leg:seriesnum">
        <xsl:text>&#10;</xsl:text><leg-seriesnum>
            <xsl:copy-of select="./@*"/>
            <xsl:apply-templates/>
        </leg-seriesnum>
    </xsl:template>
    <xsl:template match="leg:enactdate|leg:enactdate/date|leg:officialnum/leg:year">
        <xsl:variable name="tag" select="replace(name(.),':','-')"/>
        <xsl:text>&#10;</xsl:text><xsl:element name="{$tag}">
            <xsl:copy-of select="./@*"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="*" priority="-11">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="text()" priority="-11">
        <xsl:value-of select="replace(replace(.,'&#10;', ''), '  ', ' ')"/>
    </xsl:template>
    
</xsl:stylesheet>
