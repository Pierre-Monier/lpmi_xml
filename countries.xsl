<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
 <xsl:template match="countries">
  <fo:root>
   <fo:layout-master-set>
    <fo:simple-page-master master-name="only">
     <fo:region-body/>
    </fo:simple-page-master>
   </fo:layout-master-set>

   <fo:page-sequence master-reference="only">
    <fo:flow flow-name="xsl-region-body">
     <xsl:apply-templates></xsl:apply-templates>
    </fo:flow>
   </fo:page-sequence>
  </fo:root>
 </xsl:template>

 <xsl:template match="country">
  <fo:block>
   <xsl:value-of select="@name"/>
  </fo:block>
 </xsl:template>

 <xsl:template match="city">
  <li>
   <b><xsl:value-of select="name"/></b>,
   <xsl:value-of select="population"/>
  </li>
 </xsl:template>
</xsl:stylesheet>