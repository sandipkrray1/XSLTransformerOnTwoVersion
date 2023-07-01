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
    <!--<xsl:preserve-space elements="ci:cite emph"/>-->
    <xsl:strip-space elements="base:p base:entry base:heading p"/>
    
    <xsl:template match="/">
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
                    <xsl:text>&#10;</xsl:text><p><xsl:apply-templates select=" current-group()"/></p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#10;</xsl:text><p><xsl:apply-templates select=" current-group()"/></p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="base:listItemEnumerator" mode="listlabel">
        <xsl:apply-templates/><xsl:text> </xsl:text>
    </xsl:template>

    <xsl:template match="base:listItemEnumerator[following-sibling::*[1][self::base:p]]"/>
    
    <xsl:template match="base:p">
        <xsl:for-each-group select="node()" group-adjacent="exists(self::base:list|self::base:table|
            self::base:quote|self::note:marginNote|self::base:comment|self::base:definitionList|self::note:footnote|self::base:figure)">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:copy-of select="current-group()"/>-->
                    <xsl:choose>
                        <xsl:when test="current-group()/self::base:break">
                            <xsl:for-each-group select="current-group()/self::node()" group-ending-with="base:break">
                                <p>
                                    <xsl:if test="current-group()/parent::node()/preceding-sibling::*[1][self::base:listItemEnumerator] and position()=1">
                                        <xsl:apply-templates select="current-group()/parent::node()/preceding-sibling::*[1][self::base:listItemEnumerator]" mode="listlabel"/>
                                    </xsl:if>
                                    <xsl:apply-templates select="current-group()"/></p>
                            </xsl:for-each-group>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:variable name="currentgrp">
                                <xsl:value-of select="current-group()"/>
                            </xsl:variable>
                            <xsl:if test="normalize-space($currentgrp)!=''">
                                <!--<xsl:text>&#10;</xsl:text>--><p>
                                    <xsl:if test="current-group()/parent::node()/preceding-sibling::*[1][self::base:listItemEnumerator]">
                                        <xsl:apply-templates select="current-group()/parent::node()/preceding-sibling::*[1][self::base:listItemEnumerator]" mode="listlabel"/>
                                    </xsl:if>
                                    <xsl:apply-templates select="current-group()"/>
                                </p>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="base:label" mode="fnlabel">
        <xsl:text>[</xsl:text><xsl:apply-templates/><xsl:text>] </xsl:text>
    </xsl:template>

    <xsl:template match="note:footnote">
     <xsl:apply-templates select="* except base:label"/>   
    </xsl:template>
    
    <xsl:template match="note:marginNote/base:label|*:subtitle|*:fullTitle">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="note:p|form:text">
<!--        <xsl:choose>
            <xsl:when test="parent::base:listItem">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>-->
                <xsl:for-each-group select="node()" group-adjacent="exists(self::base:list|self::base:table|
                    self::base:quote|self::note:marginNote|self::base:comment|self::base:definitionList|self::note:footnote)">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--<xsl:text>&#10;</xsl:text>--><p>
                                <xsl:if test="current-group()/parent::node()/preceding-sibling::*[1][self::base:label][parent::note:footnote]!=''">
                                    <xsl:apply-templates select="current-group()/parent::node()/preceding-sibling::*[1][self::base:label][parent::note:footnote]" mode="fnlabel"/>
                                </xsl:if>
                                <xsl:apply-templates select="current-group()"/>
                            </p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            <!--</xsl:otherwise>
        </xsl:choose>-->
        
    </xsl:template>

    <xsl:template match="base:definitionTerm" mode="defterm">
        <xsl:apply-templates select="."/><xsl:text></xsl:text>
    </xsl:template>
    
    <xsl:template match="base:definitionDescription">
        <!--<xsl:choose>
            <xsl:when test="parent::base:listItem">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>-->
                <xsl:for-each-group select="node()" group-adjacent="exists(self::base:list|self::base:table|
                    self::base:quote|self::note:marginNote|self::base:comment|self::base:list|self::note:footnote)">
                    <xsl:choose>
                        <xsl:when test="current-grouping-key()">
                            <xsl:apply-templates select="current-group()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--<xsl:text>&#10;</xsl:text>--><p>
                                <xsl:if test="current-group()/parent::node()/preceding-sibling::*[1][self::base:definitionTerm]">
                                    <xsl:apply-templates select="current-group()/parent::node()/preceding-sibling::*[1][self::base:definitionTerm]" mode="defterm"/>
                                </xsl:if>
                                <xsl:apply-templates select="current-group()"/>
                            </p>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each-group>
            <!--</xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
    
    <!-- Listitem -->
    <xsl:template match="base:listItem1">
        <xsl:for-each-group select="node()" group-adjacent="exists(self::base:list|self::base:table|
            self::base:quote|self::note:marginNote|self::base:comment|self::base:definitionList|self::note:footnote)">
            <xsl:choose>
                <xsl:when test="current-grouping-key()">
                    <xsl:apply-templates select="current-group()"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:text>&#10;</xsl:text>--><p>
                        <xsl:apply-templates select="current-group()"/>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    <xsl:template match="base:designator">
        <xsl:choose>
            <xsl:when test="following-sibling::*[1][self::base:para] or following-sibling::*[1][self::base:title]">
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="base:heading">
        <xsl:choose>
            <xsl:when test="(base:designator and base:title) or base:subtitle">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:text>&#10;</xsl:text>--><p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- listItemEnumerator -->
    <xsl:template match="base:listItemEnumerator">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::*[1][self::base:para] or following-sibling::*[1][self::base:title]">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>

    <!-- designator -->
    <xsl:template match="base:designator" mode="desinator">
        <xsl:apply-templates/>
        <xsl:if test="following-sibling::*[1][self::base:para] or following-sibling::*[1][self::base:title]">
            <xsl:text> </xsl:text>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*:shortTitle|dc:identifier|dc:date|base:dateText|courtrule:title">
        <!--<xsl:text>&#10;</xsl:text>--><p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="base:title">
        <xsl:choose>
            <xsl:when test="preceding-sibling::*[1][self::base:designator]|following-sibling::base:subtitle">
                <!--<xsl:text>&#10;</xsl:text>--><p>
                    <xsl:if test="preceding-sibling::*[1][self::base:designator]">
                        <xsl:apply-templates select="preceding-sibling::*[1][self::base:designator]" mode="desinator"/>
                    </xsl:if>
                    <xsl:apply-templates/></p>
            </xsl:when>
            <xsl:when test="parent::base:heading">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:text>&#10;</xsl:text>--><p>
                    <xsl:apply-templates/>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="base:entry">
        <xsl:choose>
            <xsl:when test="base:p|form:p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <p><xsl:apply-templates/></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="base:definitionItem">
        <xsl:apply-templates select="* except base:definitionTerm"/>
    </xsl:template>
  
    <!-- Dropped elements -->
    <xsl:template match="doc:metadata"/>
    
    <xsl:template match="note:footnoteRef">
        <xsl:text>[</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>] </xsl:text>
    </xsl:template>
    
    <xsl:template match="base:graphic">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="base:externalObject">
        <p><xsl:value-of select="@versionNumber"/></p>
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="finalCleanup">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@* | node()" mode="finalCleanup"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*" priority="-11">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()" priority="-11">
        <xsl:value-of select="replace(replace(.,'&#10;', ''), '  ', ' ')"/>
    </xsl:template>
    
</xsl:stylesheet>
