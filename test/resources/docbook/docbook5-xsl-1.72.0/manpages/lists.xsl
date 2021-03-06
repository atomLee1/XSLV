<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
version='1.0'>

<!-- ********************************************************************
     $Id: lists.xsl 6524 2007-01-18 15:44:19Z xmldoc $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<xsl:variable name="list-indent">
  <xsl:choose>
    <xsl:when test="not($man.indent.lists = 0)">
      <xsl:value-of select="$man.indent.width"/>
    </xsl:when>
    <xsl:when test="not($man.indent.refsect = 0)">
      <!-- * "zq" is the name of a register we set for -->
      <!-- * preserving the original default indent value -->
      <!-- * when $man.indent.refsect is non-zero; -->
      <!-- * "u" is a roff unit specifier -->
      <xsl:text>&#x2593;n(zqu</xsl:text>
    </xsl:when>
    <xsl:otherwise/> <!-- * otherwise, just leave it empty -->
  </xsl:choose>
</xsl:variable>

<!-- ================================================================== -->

<xsl:template match="d:para[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]|
	             d:simpara[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]|
		     d:remark[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]">
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:if test="following-sibling::*[1][
                self::d:para or
                self::d:simpara or
                self::d:remark
                ]">
    <!-- * Make sure multiple paragraphs within a list item don't -->
    <!-- * merge together.                                        -->
    <xsl:text>&#x2302;sp&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:variablelist|d:glosslist">
  <xsl:if test="d:title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="d:title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:varlistentry|d:glossentry">
  <xsl:text>&#x2302;PP&#10;</xsl:text> 
  <xsl:for-each select="d:term|d:glossterm">
    <xsl:variable name="content">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($content)"/>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * if we have multiple terms in the same varlistentry, generate -->
        <!-- * a separator (", " by default) and/or an additional line -->
        <!-- * break after each one except the last -->
        <!-- * -->
        <!-- * note that it is not valid to have multiple glossterms -->
        <!-- * within a glossentry, so this logic never gets exercised -->
        <!-- * for glossterms (every glossterm is always the last in -->
        <!-- * its parent glossentry) -->
        <xsl:value-of select="$variablelist.term.separator"/>
        <xsl:if test="not($variablelist.term.break.after = '0')">
          <xsl:text>&#10;</xsl:text>
          <xsl:text>&#x2302;br&#10;</xsl:text>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text> 
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:varlistentry/d:term"/>
<xsl:template match="d:glossentry/d:glossterm"/>

<xsl:template match="d:variablelist[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]|
                     d:glosslist[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text> 
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
  <xsl:if test="following-sibling::node() or
                parent::d:para[following-sibling::node()] or
                parent::d:simpara[following-sibling::node()] or
                parent::d:remark[following-sibling::node()]">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:varlistentry/d:listitem|d:glossentry/d:glossdef">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:itemizedlist/d:listitem">
  <!-- * We output a real bullet here (rather than, "\(bu", -->
  <!-- * the roff bullet) because, when we do character-map -->
  <!-- * processing before final output, the character-map will -->
  <!-- * handle conversion of the &#x2022; to "\(bu" for us -->
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text>
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2593;h'&#x2591;</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>'</xsl:text>
  <xsl:text>&#x2022;</xsl:text>
  <xsl:text>&#x2593;h'+</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent - 1"/>
  <xsl:text>'</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:orderedlist/d:listitem|d:procedure/d:step">
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2302;RS</xsl:text>
  <xsl:if test="not($list-indent = '')">
    <xsl:text> </xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>&#10;</xsl:text>
  <xsl:text>&#x2593;h'&#x2591;</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent"/>
  </xsl:if>
  <xsl:text>'</xsl:text>
  <xsl:if test="count(preceding-sibling::d:listitem) &lt; 9">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:number format="1."/>
  <xsl:text>&#x2593;h'+</xsl:text>
    <xsl:if test="not($list-indent = '')">
    <xsl:text>0</xsl:text>
    <xsl:value-of select="$list-indent - 2"/>
  <xsl:text>'</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:text>&#x2302;RE&#10;</xsl:text>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:itemizedlist|d:orderedlist|d:procedure">
  <xsl:if test="d:title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="d:title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <!-- * DocBook allows just about any block content to appear in -->
  <!-- * lists before the actual list items, so we need to get that -->
  <!-- * content (if any) before getting the list items -->
  <xsl:apply-templates
      select="*[not(self::d:listitem) and not(self::d:title)]"/>
  <xsl:apply-templates select="d:listitem"/>
  <!-- * If this list is a child of para and has content following -->
  <!-- * it, within the same para, then add a blank line and move -->
  <!-- * the left margin back to where it was -->
  <xsl:if test="parent::d:para and following-sibling::node()">
    <xsl:text>&#x2302;sp&#10;</xsl:text>
    <xsl:text>&#x2302;RE&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:itemizedlist[ancestor::d:listitem or ancestor::d:step  or ancestor::d:glossdef]|
	             d:orderedlist[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]|
                     d:procedure[ancestor::d:listitem or ancestor::d:step or ancestor::d:glossdef]">
  <xsl:if test="d:title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="d:title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::node() or
                parent::d:para[following-sibling::node()] or
                parent::d:simpara[following-sibling::node()] or
                parent::d:remark[following-sibling::node()]">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<!-- ================================================================== -->
  
<!-- * for simplelist type="inline", render it as a comma-separated list -->
<xsl:template match="d:simplelist[@type='inline']">

  <!-- * if dbchoice PI exists, use that to determine the choice separator -->
  <!-- * (that is, equivalent of "and" or "or" in current locale), or literal -->
  <!-- * value of "choice" otherwise -->
  <xsl:variable name="localized-choice-separator">
    <xsl:choose>
      <xsl:when test="processing-instruction('dbchoice')">
	<xsl:call-template name="select.choice.separator"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- * empty -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each select="d:member">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
	<xsl:text>, </xsl:text>
	<xsl:if test="position() = last() - 1">
	  <xsl:if test="$localized-choice-separator != ''">
	    <xsl:value-of select="$localized-choice-separator"/>
	    <xsl:text> </xsl:text>
	  </xsl:if>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- * if simplelist type is not inline, render it as a one-column vertical -->
<!-- * list (ignoring the values of the type and columns attributes) -->
<xsl:template match="d:simplelist">
  <xsl:for-each select="d:member">
    <xsl:text>&#x2302;IP ""</xsl:text> 
    <xsl:if test="not($list-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$list-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

<!-- ================================================================== -->

<!-- * We output Segmentedlist as a table, using tbl(1) markup. There -->
<!-- * is no option for outputting it in manpages in "list" form. -->
<xsl:template match="d:segmentedlist">
  <xsl:if test="d:title">
    <xsl:text>&#x2302;PP&#10;</xsl:text>
    <xsl:apply-templates mode="bold" select="d:title"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
  <xsl:text>&#x2302;&#x2593;" line length increase to cope w/ tbl weirdness&#10;</xsl:text>
  <xsl:text>&#x2302;ll +(&#x2593;n(LLu * 62u / 100u)&#10;</xsl:text>
  <!-- * .TS = "Table Start" -->
  <xsl:text>&#x2302;TS&#10;</xsl:text>
    <!-- * first output the table "format" spec, which tells tbl(1) how -->
    <!-- * how to format each row and column. -->
  <xsl:for-each select=".//d:segtitle">
    <!-- * l = "left", which hard-codes left-alignment for tabular -->
    <!-- * output of all segmentedlist content -->
    <xsl:text>l</xsl:text>
  </xsl:for-each>
  <!-- * last line of table format section must end with a dot -->
  <xsl:text>&#x2302;&#10;</xsl:text>
  <!-- * optionally suppress output of segtitle -->
  <xsl:choose>
    <xsl:when test="$man.segtitle.suppress != 0">
      <!-- * non-zero = "suppress", so do nothing -->
    </xsl:when>
    <xsl:otherwise>
      <!-- * "0" = "do not suppress", so output the segtitle(s) -->
      <xsl:apply-templates select=".//d:segtitle" mode="table-title"/>
      <xsl:text>&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  <!-- * .TE = "Table End" -->
  <xsl:text>&#x2302;TE&#10;</xsl:text>
  <xsl:text>&#x2302;&#x2593;" line length decrease back to previous value&#10;</xsl:text>
  <xsl:text>&#x2302;ll &#x2591;(&#x2593;n(LLu * 62u / 100u)&#10;</xsl:text>
  <!-- * put a blank line of space below the table -->
  <xsl:text>&#x2302;sp&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:segmentedlist/d:segtitle" mode="table-title">
  <!-- * italic makes titles stand out more reliably than bold (because -->
  <!-- * some consoles do not actually support rendering of bold -->
  <xsl:apply-templates mode="italic" select="."/>
  <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
        <!-- * tbl(1) treats tab characters as delimiters between -->
        <!-- * cells; so we need to output a tab after each except -->
        <!-- * segtitle except the last one -->
        <xsl:text>&#09;</xsl:text>
      </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:segmentedlist/d:seglistitem">
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:segmentedlist/d:seglistitem/d:seg">
  <!-- * the “T{" and “T}” stuff are delimiters to tell tbl(1) that -->
  <!-- * the delimited contents are "text blocks" that groff(1) -->
  <!-- * needs to process -->
  <xsl:text>T{&#10;</xsl:text>
  <xsl:variable name="contents">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($contents)"/>
  <xsl:text>&#10;T}</xsl:text>
  <xsl:choose>
    <xsl:when test="position() = last()"/> <!-- do nothing -->
    <xsl:otherwise>
      <!-- * tbl(1) treats tab characters as delimiters between -->
      <!-- * cells; so we need to output a tab after each except -->
      <!-- * segtitle except the last one -->
      <xsl:text>&#09;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
