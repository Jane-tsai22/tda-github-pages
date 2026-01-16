<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs tei"
    version="2.0">
    
    <!-- <xsl:output method="xml" omit-xml-declaration="yes" indent="yes" /> -->
    <xsl:template match="tei:teiHeader"/>

    <xsl:template match="tei:body">
        <div class="row">
        <div class="col-3"><br/><br/><br/><br/><br/>
            <xsl:for-each select="//tei:add[@place = 'marginleft']">
                <div class="marginLeft">
                    <xsl:choose>
                        <xsl:when test="parent::tei:del">
                            <del>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand" />
                                </xsl:attribute>
                                <xsl:apply-templates/></del><br/>
                        </xsl:when>
                        <xsl:otherwise>
                            <span>
                                <xsl:attribute name="class">
                                    <xsl:value-of select="attribute::hand" />
                                </xsl:attribute>
                            <xsl:apply-templates/><br/>
                            </span>
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </xsl:for-each> 
        </div>
        <div class="col-9">
            <div class="transcription">
                <xsl:apply-templates select="//tei:div"/>
            </div>
        </div>
        </div> 
    </xsl:template>
    
    <xsl:template match="tei:div">
        <div class="hand-MWS paragraph"><xsl:apply-templates/></div>
    </xsl:template>
    


  <!-- processes the marginal additions again to give them a class to hide them in the 'main' text in css. By hiding them using css, they can also be made visible again when showing a reading text, for example-->
<xsl:template match="tei:add[@place = 'marginleft']" priority="1">
    <span>
        <xsl:attribute name="class">
            <xsl:text>marginAdd</xsl:text>
            <xsl:if test="@hand">
                <xsl:text> hand-</xsl:text>
                <xsl:value-of select="translate(@hand, '#', '')"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:apply-templates/>
    </span>
</xsl:template>
    <xsl:template match="tei:add[@place = 'above']">
        <sup><xsl:if test="@hand">
                <xsl:attribute name="class">
                    <xsl:text>sup hand-</xsl:text> <xsl:value-of select="translate(@hand, '#', '')"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    


    
    <!-- all the supralinear additions are given in a span with the class supraAdd, make sure to put this class in superscript in the CSS file, -->
    <xsl:template match="tei:add[@place = 'supralinear']">
        <span>
            <xsl:attribute name="class">
                <xsl:text>supraAdd</xsl:text>
            
                <xsl:if test="@hand">
                    <xsl:text> hand-</xsl:text>
                    <xsl:value-of select="translate(@hand, '#', '')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
   
    
    <!-- add additional templates below, for example to transform the tei:lb in <br/> empty elements, tei:hi[@rend = 'sup'] in <sup> elements, the underlined text, additions with the attribute "overwritten" etc. -->
 <xsl:template match="tei:add">
    <add>
        
        <xsl:if test="@hand">
            
            <xsl:attribute name="class">
                
                <xsl:text>hand-</xsl:text>
                
                <xsl:value-of select="translate(@hand, '#', '')"/>
                
            </xsl:attribute>
        </xsl:if>

        <xsl:apply-templates/>
    </add>
</xsl:template>
<xsl:template match="tei:del">
    <del>
        <xsl:if test="@hand">
            <xsl:attribute name="class">
                <xsl:text>hand-</xsl:text>
                <xsl:value-of select="translate(@hand, '#', '')"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates/>
    </del>
</xsl:template>
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
     <xsl:template match="tei:l">
     <xsl:apply-templates/>
        <br/>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'sup']">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    
    <xsl:template match="tei:hi[@rend = 'italic']">
        <i>
            <xsl:apply-templates/>
        </i>
    </xsl:template>
    
     
    <xsl:template match="tei:hi[@rend = 'underline']">
        <span style="text-decoration: underline;">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    <xsl:template match="tei:item">
        <p class="verse-line">
            <xsl:if test="@rend='right'">
                <xsl:attribute name="class">verse-line right-align</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="tei:metamark[@function='insertion']">
        <span class="metamark-below">
            <xsl:apply-templates/>
        </span>
    </xsl:template>   
    <xsl:template match="tei:note">
    </xsl:template>
    <xsl:template match="tei:choice">
        <del><xsl:apply-templates select="tei:sic"/></del>
        <ins><xsl:apply-templates select="tei:corr"/></ins>
    </xsl:template>
    <xsl:template match="tei:add[@status = 'overwritten']">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>
    <xsl:template match="tei:hi[@rend = 'double-underline']">
        <span class="double-underline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
<xsl:template match="tei:p">
    <div>
        <xsl:attribute name="class">
            <xsl:text>hand-MWS paragraph</xsl:text>
            
            <xsl:if test="@rend = 'indent'">
                <xsl:text> indented-paragraph</xsl:text>
            </xsl:if>
        </xsl:attribute>

        <xsl:apply-templates/>
    </div>
</xsl:template>

</xsl:stylesheet>
<xsl:variable name="pageSequence">
        <page id="21r" file="21r.html"/>
        <page id="21v" file="21v.html"/>
        <page id="22r" file="22r.html"/>
        <page id="22v" file="22v.html"/>
        <page id="23r" file="23r.html"/>
        <page id="23v" file="23v.html"/>
        <page id="24r" file="24r.html"/>
        <page id="24v" file="24v.html"/>
        <page id="25r" file="25r.html"/>
        <page id="25v" file="25v.html"/>
    </xsl:variable>

    <xsl:variable name="folioID" select="//tei:idno"/>
