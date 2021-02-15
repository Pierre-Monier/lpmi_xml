<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:template match="countries">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="garde">
                    <fo:region-body margin-top="25%" />
                    <fo:region-before />
                    <fo:region-after extent="1.0in" />
                </fo:simple-page-master>
                <fo:simple-page-master master-name="sommaire">
                    <fo:region-body column-count="2" margin="1.0in" />
                    <fo:region-after extent="1.0in" />
                </fo:simple-page-master>
                <fo:page-sequence-master master-name="contents">
                    <fo:repeatable-page-master-reference master-reference="data" />
                </fo:page-sequence-master>
                <fo:simple-page-master master-name="data">
                    <fo:region-body margin="1.0in" />
                    <fo:region-after extent="1.0in" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <!-- PAGE DE GARDE -->
            <fo:page-sequence master-reference="garde" initial-page-number="1">
                <fo:title>
                    Page de garde
                </fo:title>
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block text-align="center" margin-top="5%" font-size="48pt" font-weight="bold" id="tmp">Liste de pays</fo:block>
                </fo:static-content>
                <fo:static-content flow-name="xsl-region-after">
                    <xsl:call-template name="footer" />
                </fo:static-content>

                <fo:flow flow-name="xsl-region-body">
                    <fo:block>
                        <fo:external-graphic src="https://www.nationsonline.org/gallery/World/World-map-countries-flags.jpg" content-height="scale-to-fit" content-width="21.00cm" scaling="non-uniform" />
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
            <!-- fin -->
            <!-- PAGE SOMMAIRE -->
            <fo:page-sequence master-reference="sommaire">
                <fo:title>
                    Sommaire
                </fo:title>
                <fo:static-content flow-name="xsl-region-after">
                    <xsl:call-template name="footer" />
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="//country" mode="sommaire"></xsl:apply-templates>
                </fo:flow>
            </fo:page-sequence>
            <!-- fin -->
            <!-- PAGE DATA -->
            <fo:page-sequence master-reference="data">
                <fo:flow flow-name="xsl-region-body">
                    <xsl:apply-templates select="//country" mode="data"></xsl:apply-templates>
                </fo:flow>
            </fo:page-sequence>
            <!-- fin -->
        </fo:root>
    </xsl:template>

    <xsl:template match="country" mode="sommaire">
        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

        <xsl:variable name="linkId">
            <xsl:value-of select="translate(@name, $uppercase, $lowercase)" />
        </xsl:variable>
        <fo:block text-decoration="underline" color="blue">
            <fo:basic-link internal-destination="{$linkId}">
                <xsl:value-of select="@name" />
            </fo:basic-link>
        </fo:block>
    </xsl:template>

    <xsl:template match="country" mode="data">
        <xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'" />
        <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

        <xsl:variable name="id">
            <xsl:value-of select="translate(@name, $uppercase, $lowercase)" />
        </xsl:variable>
        <xsl:variable name="totalPopulation">
            <xsl:value-of select="@population" />
        </xsl:variable>

        <xsl:variable name="pre" select="string(concat('svg/', $id))" />
        <xsl:variable name="final" select="string(concat($pre,'.svg'))" />

        <fo:block break-after="page">
            <fo:block text-align="center" font-size="24pt" font-weight="bold" id="{$id}">
                <xsl:value-of select="@name" />
                <fo:instream-foreign-object width="10%" content-width="scale-to-fit">
                    <xsl:copy-of select="document(translate($final, ' ', '-'))/*" />
                </fo:instream-foreign-object>
            </fo:block>

            <fo:block>
                Population:
                <xsl:value-of select="translate(format-number(@population, '#,###'), ',', ' ' )" />
                hab
            </fo:block>
            <fo:block>
                Superficies:
                <xsl:value-of select="translate(format-number(@area, '#,###'), ',', ' ' )" />
                km2
            </fo:block>
            <xsl:if test="city">
                <fo:block>
                    Liste des villes:
                    <xsl:for-each select="city">
                        <fo:block>
                            <xsl:value-of select="name" />
                            :
                            <xsl:value-of select="translate(format-number(population, '#,###'), ',', ' ' )" />
                            hab,
                            <xsl:value-of select='format-number(population div $totalPopulation, "#%")' />
                        </fo:block>
                    </xsl:for-each>
                </fo:block>
            </xsl:if>

            <xsl:if test="language">
                <fo:block>
                    Language(s):
                    <xsl:for-each select="language">
                        <fo:block>
                            Langue:
                            <xsl:value-of select="current()" />
                            parlé à
                            <xsl:value-of select='@percentage' />
                            %
                        </fo:block>
                    </xsl:for-each>
                    <fo:block>
                        <fo:instream-foreign-object>
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="-1 -1 2 2">
                                <circle fill="gray" r="1" cx="0" cy="0" />
                                <xsl:variable name="startX" select="'1'" />
                                <xsl:variable name="startY" select="'0'" />
                                <xsl:for-each select="language">
                                    <xsl:variable name="endX" select="0" />
                                    <xsl:variable name="endY" select="1" />

                                    <path d="M {$startX} {$startY} A 1 1 0 0 1 {$endX} {$endY} L 0 0" fill="red"></path>

                                    <xsl:variable name="startX" select="$endX" />
                                    <xsl:variable name="startY" select="$endY" />
                                </xsl:for-each>
                            </svg>
                        </fo:instream-foreign-object>
                    </fo:block>
                </fo:block>
            </xsl:if>

        </fo:block>
    </xsl:template>

    <xsl:template match="city">
        <fo:block>
            <xsl:value-of select="@name" />
        </fo:block>
    </xsl:template>

    <xsl:template name="footer">
        <fo:block>
            <fo:leader leader-pattern="rule" leader-length="100%" />
        </fo:block>
        <fo:block>
            p.
            <fo:page-number />
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
