        ��  ��                    ,   ��
 C O N T R I B       0        
  W aplikacji u�yto nast�puj�cych komponent�w

  1) <b>VirtualTreeView</b> - wersja 4.8.5
     Mike Lischke, public@soft-gems.net
     http://www.soft-gems.net/

  2) <b>MemCheck</b> - wersja 2.73
     Vincent Mahon, Vincent.Mahon@free.fr
     http://v.mahon.free.fr/pro/freeware/memcheck

  3) <b>PngComponents</b> - wersja 1.0 RC3
     Martijn Saly, martijn@thany.org
     http://www.thany.org

  4) <b>HtmlHelp</b> - wersja 1.8
     The Helpware Group, support@helpware.net
     http://www.helpware.net

  W aplikacji u�yto ikon z nast�puj�cych pakiet�w

  5) <b>Crystal</b>
     Everaldo Coelho, contact@everaldo.com
     http://www.everaldo.com/crystal/

  6) <b>Nuvola</b> - wersja 1.0
     David Vignoni, Icon King
     http://www.icon-king.com  
  ,   ��
 R E P C S S         0        body
{
color: black;
font-family: Verdana, Arial;
font-size: 12px;
background-color: white;
}
table.base
{
border: 0px;
border-collapse: collapse;
width: 100%;
}
tr.base
{
height: 25px
}
tr.evenbase
{
height: 25px;
background-color: #F5F5F5;
}
tr.head
{
height: 25px;
background-color: #CCFFCC;
}
tr.evenhead
{
height: 25px;
background-color: #CCFACC;
}
tr.subhead
{
height: 25px;
background-color: #CCFF99;
}
tr.evensubhead
{
height: 25px;
background-color: #CCFF90;
}
tr.sum
{
height: 25px;
background-color: #CCCCFF;
}
tr.evensum
{
height: 25px;
background-color: #C2C2F5;
}
td.cash
{
padding-left: 8px;
padding-right: 8px;
text-align: right;
}
td.text
{
padding-left: 8px;
padding-right: 8px;
text-align: left;
}
td.center
{
padding-left: 8px;
padding-right: 8px;
text-align: center;
}
td.left
{
padding-left: 8px;
padding-right: 8px;
text-align: left;
}
td.right
{
padding-left: 8px;
padding-right: 8px;
text-align: right;
}
td.infocolumnleft
{
padding-left: 8px;
padding-right: 8px;
text-align: left;
background-color: white;
}
td.infocolumnright
{
padding-left: 8px;
padding-right: 8px;
text-align: right;
background-color: white;
}
td.infocolumncenter
{
padding-left: 8px;
padding-right: 8px;
text-align: center;
background-color: white;
}
td.infotext
{
padding-left: 8px;
padding-right: 8px;
font-size: 10px;
text-align: left;
}
td.headtext
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: left;
}
td.headcenter
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: center;
}
td.headleft
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: left;
}
td.headcash
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: right;
}
td.subheadtext
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: left;
}
td.subheadcenter
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: center;
}
td.subheadcash
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: right;
}
td.sumtext
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: left;
}
td.sumcash
{
padding-left: 8px;
padding-right: 8px;
font-weight: bold;
text-align: right;
}
hr
{
height: 1px;
width: 100%;
}
.reptitle
{
font-size: 16px;
font-weight: bold;
color: navy;
font-family: Verdana, Arial;
}
.repfooter
{
font-size: 10px;
color: navy;
font-family: Verdana, Arial;
text-align: right;
}Z  ,   ��
 R E P B A S E       0        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=Windows-1250">
  <title>[reptitle]</title>
  <style type="text/css">[repstyle]</style>
</head>
<body>
<p class="reptitle">[reptitle]
<hr>
[repbody]
<hr>
<div class="repfooter">[repfooter]
</body>
</html>
  �  ,   ��
 R E P X S L         0        <?xml version="1.0" encoding="Windows-1250"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="html" encoding="Windows-1250" doctype-public="-//W3C//DTD HTML 4.01//EN"/>
	<xsl:template match="/">
	  <xsl:param name="colwidth" select="100 div count(//recordset/header/field)"/>
		<html>
			<style type="text/css">[repstyle]</style>
			<body>
			  <div class="reptitle">[reptitle]</div>
			  <hr/>
				<table class="base">
					<tr class="head">
						<xsl:for-each select="recordset/header/field">
						  <xsl:text disable-output-escaping="yes">&lt;td class=&quot;headtext&quot; width=&quot;</xsl:text>
							<xsl:copy-of select="$colwidth"/>
							<xsl:text disable-output-escaping="yes">%&quot;&gt;</xsl:text>
							<xsl:value-of select="." />
							<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
						</xsl:for-each>
					</tr>
				</table>
				<hr/>
				<table class="base">
					<xsl:for-each select="recordset/content/row">
						<xsl:choose>
							<xsl:when test="position() mod 2">
								<tr class="base">
									<xsl:for-each select="field">
									  <xsl:text disable-output-escaping="yes">&lt;td class=&quot;text&quot; width=&quot;</xsl:text>
										<xsl:copy-of select="$colwidth"/>
										<xsl:text disable-output-escaping="yes">%&quot;&gt;</xsl:text>
										<xsl:value-of select="." />
										<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
									</xsl:for-each>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr class="evenbase">
									<xsl:for-each select="field">
									  <xsl:text disable-output-escaping="yes">&lt;td class=&quot;text&quot; width=&quot;</xsl:text>
										<xsl:copy-of select="$colwidth"/>
										<xsl:text disable-output-escaping="yes">%&quot;&gt;</xsl:text>
										<xsl:value-of select="." />
										<xsl:text disable-output-escaping="yes">&lt;/td&gt;</xsl:text>
									</xsl:for-each>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</table>
			<hr/>
		  <div class="repfooter">[repfooter]</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>   �  0   ��
 R A T E S X S D         0        <?xml version="1.0" encoding="Windows-1250"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="currencyRates">
    <xs:complexType>
      <xs:sequence>
        <xs:element minOccurs="0" maxOccurs="unbounded" name="currencyRate">
          <xs:complexType>
            <xs:attribute name="sourceName" type="xs:string" />
            <xs:attribute name="sourceIso" type="xs:string" use="required" />
            <xs:attribute name="targetName" type="xs:string" />
            <xs:attribute name="targetIso" type="xs:string" use="required" />
            <xs:attribute name="quantity" type="xs:integer" use="required" />
            <xs:attribute name="rate" type="xs:double" use="required" />
            <xs:attribute name="type">
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="A"/>  <!--kurs �redni-->
                  <xs:enumeration value="B"/>  <!--kurs sprzeda�y-->
                  <xs:enumeration value="S"/>  <!--kurs kupna-->
                </xs:restriction>
              </xs:simpleType>
            </xs:attribute>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
      <xs:attribute name="cashpointName" type="xs:string" use="required" />
      <xs:attribute name="bindingDate" type="xs:date" use="required" />
    </xs:complexType>
  </xs:element>
</xs:schema>
  �  <   ��
 E X T R A C T I O N S X S D         0        <?xml version="1.0" encoding="Windows-1250"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="accountExtraction">
    <xs:complexType>
      <xs:sequence>
        <xs:element minOccurs="0" maxOccurs="unbounded" name="extractionItem">
          <xs:complexType>
            <xs:attribute name="operationDate" type="xs:date" use="required" />
            <xs:attribute name="accountingDate" type="xs:date" use="required" />
            <xs:attribute name="type" use="required">
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="I"/>  <!--operacja przychodowa-->
                  <xs:enumeration value="O"/>  <!--operacja rozchodowa-->
                </xs:restriction>
              </xs:simpleType>
            </xs:attribute>
            <xs:attribute name="cash" type="xs:double" use="required" />
            <xs:attribute name="currency" type="xs:string" use="required" />
            <xs:attribute name="description" type="xs:string" />	    
          </xs:complexType>
        </xs:element>
      </xs:sequence>
      <xs:attribute name="creationDate" type="xs:date" use="required" />
      <xs:attribute name="startDate" type="xs:date" use="required" />
      <xs:attribute name="endDate" type="xs:date" use="required" />
      <xs:attribute name="description" type="xs:string" />
    </xs:complexType>
  </xs:element>
</xs:schema>








�
  8   ��
 E X C H A N G E S X S D         0        <?xml version="1.0" encoding="Windows-1250"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="exchanges">
    <xs:complexType>
      <xs:sequence>
        <xs:element minOccurs="0" maxOccurs="unbounded" name="stockExchange">
          <xs:complexType>
            <xs:sequence>
              <xs:element minOccurs="0" maxOccurs="unbounded" name="exchange">
                <xs:complexType>
                  <xs:attribute name="identifier" use="required">
                    <xs:simpleType>
                      <xs:restriction base="xs:string">
                        <xs:minLength value="1"/>
                        <xs:maxLength value="40"/>
                        <xs:whiteSpace value="collapse"/>
                      </xs:restriction>
                    </xs:simpleType>    
                  </xs:attribute>
                  <xs:attribute name="regDateTime" type="xs:dateTime" use="required" />
                  <xs:attribute name="value" type="xs:double" use="required" />
                </xs:complexType>
              </xs:element>
            </xs:sequence>
            <xs:attribute name="cashpointName" use="required" >
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:minLength value="1"/>
                  <xs:maxLength value="40"/>
                  <xs:whiteSpace value="collapse"/>
                </xs:restriction>
              </xs:simpleType>	    
            </xs:attribute>
            <xs:attribute name="currency" type="xs:string" use="optional" />
            <xs:attribute name="instrumentType" use="optional">
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="I"/>  <!--indeks-->
                  <xs:enumeration value="S"/>  <!--akcje-->
                  <xs:enumeration value="B"/>  <!--obligacje-->
                  <xs:enumeration value="F"/>  <!--fundusze inwestycyjne-->
                  <xs:enumeration value="R"/>  <!--fundusze emerytalne-->
                  <xs:enumeration value="U"/>  <!--niezdefiniowane-->
                </xs:restriction>
              </xs:simpleType>
            </xs:attribute>
            <xs:attribute name="searchType" use="required">
              <xs:simpleType>
                <xs:restriction base="xs:string">
                  <xs:enumeration value="S"/>  <!--wyszukiwanie po symbolu-->
                  <xs:enumeration value="N"/>  <!--wyszukiwanie po nazwie-->
                </xs:restriction>
              </xs:simpleType>
            </xs:attribute>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
 �  0   ��
 C H A R T S X S D       0        <?xml version="1.0" encoding="Windows-1250"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="charts">
    <xs:complexType>
      <xs:sequence>
        <xs:element name="chart"  minOccurs="0" maxOccurs="unbounded">
          <xs:complexType>
            <xs:sequence>
              <xs:element minOccurs="0" maxOccurs="unbounded" name="serie">
                <xs:complexType>
                  <xs:sequence>
                    <xs:element minOccurs="0" maxOccurs="unbounded" name="item">
                      <xs:complexType>
                        <xs:attribute name="domain">
			  <xs:simpleType>
			    <xs:union>
     			      <xs:simpleType>
                                <xs:restriction base="xs:float"/>
			      </xs:simpleType>	
			      <xs:simpleType>
                                <xs:restriction base="xs:date"/>			
			      </xs:simpleType>
			      <xs:simpleType>
                                <xs:restriction base="xs:dateTime"/>			
			      </xs:simpleType>
			    </xs:union>
			  </xs:simpleType>
			</xs:attribute>
                        <xs:attribute name="value" type="xs:string" use="required" />
                        <xs:attribute name="label" type="xs:string" />
                        <xs:attribute name="mark" type="xs:string" />
                      </xs:complexType>
                    </xs:element>
                  </xs:sequence>
                  <xs:attribute name="type" use ="required">
                    <xs:simpleType>
                      <xs:restriction base="xs:integer">
                      <xs:enumeration value="1"/>  <!--seria ko�owa-->
                      <xs:enumeration value="2"/>  <!--seria liniwa-->
                      <xs:enumeration value="3"/>  <!--seria s�upkowa-->
                    </xs:restriction>
		  </xs:simpleType>
		  </xs:attribute>
                  <xs:attribute name="title" type="xs:string" />
                  <xs:attribute name="domain" use="required">
                    <xs:simpleType>
                      <xs:restriction base="xs:integer">
                        <xs:enumeration value="0"/> <!--na osi x warto�ciami s� daty-->
                        <xs:enumeration value="1"/> <!--na osi x warto�ciami s� liczby-->
                      </xs:restriction>
		    </xs:simpleType>
		  </xs:attribute>
                </xs:complexType>
              </xs:element>
            </xs:sequence>
            <xs:attribute name="symbol" type="xs:string" use="required" />
            <xs:attribute name="thumbTitle" type="xs:string" />
            <xs:attribute name="chartTitle" type="xs:string" />
            <xs:attribute name="chartFooter" type="xs:string" />
            <xs:attribute name="axisx" type="xs:string" />
            <xs:attribute name="axisy" type="xs:string" />
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:element>
</xs:schema>
   N5  4   ��
 D E F A U L T X S L         0        <xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
   <xsl:output indent="no" method="html"/>
   <xsl:template match="/">
      <HTML>
         <HEAD>
            <SCRIPT>
               <xsl:comment><![CDATA[
                  function f(e){
                     if (e.className=="ci") {
                       if (e.children(0).innerText.indexOf("\n")>0) fix(e,"cb");
                     }
                     if (e.className=="di") {
                       if (e.children(0).innerText.indexOf("\n")>0) fix(e,"db");
                     } e.id="";
                  }
                  function fix(e,cl){
                    e.className=cl;
                    e.style.display="block";
                    j=e.parentElement.children(0);
                    j.className="c";
                    k=j.children(0);
                    k.style.visibility="visible";
                    k.href="#";
                  }
                  function ch(e) {
                    mark=e.children(0).children(0);
                    if (mark.innerText=="+") {
                      mark.innerText="-";
                      for (var i=1;i<e.children.length;i++) {
                        e.children(i).style.display="block";
                      }
                    }
                    else if (mark.innerText=="-") {
                      mark.innerText="+";
                      for (var i=1;i<e.children.length;i++) {
                        e.children(i).style.display="none";
                      }
                    }
                  }
                  function ch2(e) {
                    mark=e.children(0).children(0);
                    contents=e.children(1);
                    if (mark.innerText=="+") {
                      mark.innerText="-";
                      if (contents.className=="db"||contents.className=="cb") {
                        contents.style.display="block";
                      }
                      else {
                        contents.style.display="inline";
                      }
                    }
                    else if (mark.innerText=="-") {
                      mark.innerText="+";
                      contents.style.display="none";
                    }
                  }
                  function cl() {
                    e=window.event.srcElement;
                    if (e.className!="c") {
                      e=e.parentElement;
                      if (e.className!="c") {
                        return;
                      }
                    }
                    e=e.parentElement;
                    if (e.className=="e") {
                      ch(e);
                    }
                    if (e.className=="k") {
                      ch2(e);
                    }
                  }
                  function ex(){}
                  function h(){window.status=" ";}
                  document.onclick=cl;
              ]]>
              </xsl:comment>
            </SCRIPT>
            <STYLE>
              BODY {font:x-small 'Verdana'; margin-right:1.5em}
                .c  {cursor:hand}
                .b  {color:red; font-family:'Courier New'; font-weight:bold;
                     text-decoration:none}
                .e  {margin-left:1em; text-indent:-1em; margin-right:1em}
                .k  {margin-left:1em; text-indent:-1em; margin-right:1em}
                .t  {color:#990000}
                .xt {color:#990099}
                .ns {color:red}
                .dt {color:green}
                .m  {color:blue}
                .tx {font-weight:bold}
                .db {text-indent:0px; margin-left:1em; margin-top:0px;
                     margin-bottom:0px;padding-left:.3em;
                     border-left:1px solid #CCCCCC; font:small Courier}
                .di {font:small Courier}
                .d  {color:blue}
                .pi {color:blue}
                .cb {text-indent:0px; margin-left:1em; margin-top:0px;
                     margin-bottom:0px;padding-left:.3em; font:small Courier;
                     color:#888888}
                .ci {font:small Courier; color:#888888}
                PRE {margin:0px; display:inline}
           </STYLE>
         </HEAD>
         <BODY class="st">
            <xsl:apply-templates/>
         </BODY>
      </HTML>
   </xsl:template>

   <xsl:template match="processing-instruction()">
      <DIV class="e">
         <SPAN class="b">
            <xsl:call-template name="entity-ref">
               <xsl:with-param name="name">nbsp</xsl:with-param>
            </xsl:call-template>
         </SPAN>
         <SPAN class="m">
            <xsl:text>&lt;?</xsl:text>
         </SPAN>
         <SPAN class="pi">
            <xsl:value-of select="name(.)"/>
            <xsl:value-of select="."/>
         </SPAN>
         <SPAN class="m">
            <xsl:text>?></xsl:text>
         </SPAN>
      </DIV>
   </xsl:template>

   <xsl:template match="processing-instruction('xml')">
      <DIV class="e">
         <SPAN class="b">
            <xsl:call-template name="entity-ref">
               <xsl:with-param name="name">nbsp</xsl:with-param>
            </xsl:call-template>
         </SPAN>
         <SPAN class="m">
            <xsl:text>&lt;?</xsl:text>
         </SPAN>
         <SPAN class="pi">
            <xsl:text>xml </xsl:text>
            <xsl:for-each select="@*">
               <xsl:value-of select="name(.)"/>
               <xsl:text>="</xsl:text>
               <xsl:value-of select="."/>
               <xsl:text>" </xsl:text>
            </xsl:for-each>
         </SPAN>
         <SPAN class="m">
            <xsl:text>?></xsl:text>
         </SPAN>
      </DIV>
   </xsl:template>

   <xsl:template match="@*">
      <SPAN>
         <xsl:attribute name="class">
            <xsl:if test="xsl:*/@*">
              <xsl:text>x</xsl:text>
            </xsl:if>
            <xsl:text>t</xsl:text>
         </xsl:attribute>
         <xsl:value-of select="name(.)"/>
      </SPAN>
      <SPAN class="m">="</SPAN>
      <B>
         <xsl:value-of select="."/>
      </B>
      <SPAN class="m">"</SPAN>
   </xsl:template>

   <xsl:template match="text()">
      <DIV class="e">
         <SPAN class="b"> </SPAN>
         <SPAN class="tx">
            <xsl:value-of select="."/>
         </SPAN>
      </DIV>
   </xsl:template>

   <xsl:template match="comment()">
      <DIV class="k">
         <SPAN>
            <A STYLE="visibility:hidden" class="b" onclick="return false" onfocus="h()">-</A>
            <SPAN class="m">
               <xsl:text>&lt;!--</xsl:text>
            </SPAN>
         </SPAN>
         <SPAN class="ci" id="clean">
            <PRE>
               <xsl:value-of select="."/>
            </PRE>
         </SPAN>
         <SPAN class="b">
            <xsl:call-template name="entity-ref">
               <xsl:with-param name="name">nbsp</xsl:with-param>
            </xsl:call-template>
         </SPAN>
         <SPAN class="m">
            <xsl:text>--></xsl:text>
         </SPAN>
         <SCRIPT>f(clean);</SCRIPT>
      </DIV>
   </xsl:template>

   <xsl:template match="*">
      <DIV class="e">
         <DIV STYLE="margin-left:1em;text-indent:-2em">
            <SPAN class="b">
               <xsl:call-template name="entity-ref">
                  <xsl:with-param name="name">nbsp</xsl:with-param>
               </xsl:call-template>
            </SPAN>
            <SPAN class="m">&lt;</SPAN>
            <SPAN>
               <xsl:attribute name="class">
                  <xsl:if test="xsl:*">
                     <xsl:text>x</xsl:text>
                  </xsl:if>
                  <xsl:text>t</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="@*">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </SPAN>
            <xsl:apply-templates select="@*"/>
            <SPAN class="m">
               <xsl:text>/></xsl:text>
            </SPAN>
         </DIV>
      </DIV>
   </xsl:template>

   <xsl:template match="*[node()]">
      <DIV class="e">
         <DIV class="c">
            <A class="b" href="#" onclick="return false" onfocus="h()">-</A>
            <SPAN class="m">&lt;</SPAN>
            <SPAN>
               <xsl:attribute name="class">
                  <xsl:if test="xsl:*">
                     <xsl:text>x</xsl:text>
                  </xsl:if>
                  <xsl:text>t</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="@*">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </SPAN>
            <xsl:apply-templates select="@*"/>
            <SPAN class="m">
               <xsl:text>></xsl:text>
            </SPAN>
         </DIV>
         <DIV>
            <xsl:apply-templates/>
            <DIV>
               <SPAN class="b">
                  <xsl:call-template name="entity-ref">
                     <xsl:with-param name="name">nbsp</xsl:with-param>
                  </xsl:call-template>
               </SPAN>
               <SPAN class="m">
                  <xsl:text>&lt;/</xsl:text>
               </SPAN>
               <SPAN>
                  <xsl:attribute name="class">
                     <xsl:if test="xsl:*">
                        <xsl:text>x</xsl:text>
                     </xsl:if>
                     <xsl:text>t</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="name(.)"/>
               </SPAN>
               <SPAN class="m">
                  <xsl:text>></xsl:text>
               </SPAN>
            </DIV>
         </DIV>
      </DIV>
   </xsl:template>

   <xsl:template match="*[text() and not (comment() or processing-instruction())]">
      <DIV class="e">
         <DIV STYLE="margin-left:1em;text-indent:-2em">
            <SPAN class="b">
               <xsl:call-template name="entity-ref">
                  <xsl:with-param name="name">nbsp</xsl:with-param>
               </xsl:call-template>
            </SPAN>
            <SPAN class="m">
               <xsl:text>&lt;</xsl:text>
            </SPAN>
            <SPAN>
               <xsl:attribute name="class">
                  <xsl:if test="xsl:*">
                     <xsl:text>x</xsl:text>
                  </xsl:if>
                  <xsl:text>t</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="@*">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </SPAN>
            <xsl:apply-templates select="@*"/>
            <SPAN class="m">
               <xsl:text>></xsl:text>
            </SPAN>
            <SPAN class="tx">
               <xsl:value-of select="."/>
            </SPAN>
            <SPAN class="m">&lt;/</SPAN>
            <SPAN>
               <xsl:attribute name="class">
                  <xsl:if test="xsl:*">
                     <xsl:text>x</xsl:text>
                  </xsl:if>
                  <xsl:text>t</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="name(.)"/>
            </SPAN>
            <SPAN class="m">
               <xsl:text>></xsl:text>
            </SPAN>
         </DIV>
      </DIV>
   </xsl:template>

   <xsl:template match="*[*]" priority="20">
      <DIV class="e">
         <DIV STYLE="margin-left:1em;text-indent:-2em" class="c">
            <A class="b" href="#" onclick="return false" onfocus="h()">-</A>
            <SPAN class="m">&lt;</SPAN>
            <SPAN>
               <xsl:attribute name="class">
                  <xsl:if test="xsl:*">
                     <xsl:text>x</xsl:text>
                  </xsl:if>
                  <xsl:text>t</xsl:text>
               </xsl:attribute>
               <xsl:value-of select="name(.)"/>
               <xsl:if test="@*">
                  <xsl:text> </xsl:text>
               </xsl:if>
            </SPAN>
            <xsl:apply-templates select="@*"/>
            <SPAN class="m">
               <xsl:text>></xsl:text>
            </SPAN>
         </DIV>
         <DIV>
            <xsl:apply-templates/>
            <DIV>
               <SPAN class="b">
                  <xsl:call-template name="entity-ref">
                     <xsl:with-param name="name">nbsp</xsl:with-param>
                  </xsl:call-template>
               </SPAN>
               <SPAN class="m">
                  <xsl:text>&lt;/</xsl:text>
               </SPAN>
               <SPAN>
                  <xsl:attribute name="class">
                     <xsl:if test="xsl:*">
                        <xsl:text>x</xsl:text>
                     </xsl:if>
                     <xsl:text>t</xsl:text>
                  </xsl:attribute>
                  <xsl:value-of select="name(.)"/>
               </SPAN>
               <SPAN class="m">
                  <xsl:text>></xsl:text>
               </SPAN>
            </DIV>
         </DIV>
      </DIV>
   </xsl:template>
   <xsl:template name="entity-ref">
      <xsl:param name="name"/>
      <xsl:text disable-output-escaping="yes">&amp;</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>;</xsl:text>
   </xsl:template>
</xsl:stylesheet>  2  <   ��
 P L _ 0 0 1 0 0 4 0 0 0 0 0 0       0        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=Windows-1250">
	</head>
	<body style="color: clWindowText; font-family: Verdana, Arial; font-size: 12px; background-color: clWindow;">
         W zwi�zku ze zmianami wewn�trznymi pliku konfiguracji skasowane zostan� ustawienia (szeroko��, widoczno��, pozycja)
         kolumn dla wszystkich list wy�wietlaj�cych dane w programie, oraz ustawienia wykres�w.
         Zastosowane zostan� domy�lne ustawienia.
	</body>
</html>
    <   ��
 P L _ 0 0 1 0 0 8 0 0 2 0 0 0       0        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=Windows-1250">
	</head>
	<body style="color: clWindowText; font-family: Verdana, Arial; font-size: 12px; background-color: clWindow;">
         Ta wersja CManager-a jako jedn� z wielu zmian wprowadza mo�liwo�� zdefiniowania wielko�ci ikon jakie s� wy�wietlane
         na wszystkich panelach z przyciskami. Je�eli chcesz mo�esz teraz wprowadzi� globalne ustawienia dla wielko�ci ikon.<br><br>
         <div style="padding-left: 40px">
           <input type="radio" name="icon" value="big" CHECKED>Pozostaw wszystko jak do tej pory (du�e ikony)<br>
           <input type="radio" name="icon" value="small">Chc� mie� wsz�dzie ma�e ikony
         </div><br>
         Oczywi�cie w ka�dej chwili b�dziesz m�g� zmieni� te ustawienia dla ka�dego z paneli z przyciskami osobno. Wystarczy, �e
         klikniesz na nim prawym przyciskiem myszy i wybierzesz z menu kontekstowego wielko�� ikon.
	</body>
</html>
    <   ��
 P L _ 0 0 1 0 1 0 0 0 2 0 0 0       0        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=Windows-1250">
	</head>
	<body style="color: clWindowText; font-family: Verdana, Arial; font-size: 12px; background-color: clWindow;">
        Aby zwi�kszy� bezpiecze�stwo danych oraz umo�liwi� wielu u�ytkownikom na posiadanie w�asnych ustawie�, nast�puj�ce pliki konfiguracyjne
		<ul>
			<li>CManager.cfg - plik z ustawieniami wygl�du
			<li>Report.htm - domy�lny szablon raport�w
			<li>Report.css - domy�lny arkusz styli raport�w
			<li>Transform.xml - domy�lna transformacja raport�w
		</ul>
		znajduj�ce si� aktualnie w katalogu instalacyjnym CManager-a "@kataloginstalacji@", zostan� przeniesione do katalogu 
		u�ytkownika "@kataloguzytkownika@".<br>
		Po przeniesieniu plik�w do katalogu u�ytkownika, pliki znajduj�ce si� w katalogu instalacji mog� zosta� bezpiecznie usuni�te.
        Czy chcesz aby zb�dne pliki usun�� teraz?<br>
        <div style="padding-left: 40px;"><br>
			<input type="radio" name="kill" value="yes" CHECKED>Tak, usu� pliki gdy� CManager-a u�ywam tylko Ja<br>
			<input type="radio" name="kill" value="no">Nie, pozostaw pliki, gdy� opr�cz mnie CManager-a u�ywaj� inne osoby
		</div>
	</body>
</html>
P  <   ��
 P L _ 0 0 1 0 1 2 0 0 1 0 0 0       0        <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=Windows-1250">
	</head>
	<body style="color: clWindowText; font-family: Verdana, Arial; font-size: 12px; background-color: clWindow;">
         Ta wersja CManager-a zawiera zmodyfikowane domy�lne ustawienia wtyczki do pobierania notowa� GPW (wtyczki Metastock).
         CManager mo�e automatycznie zast�pi� twoje ustawienia domy�lnymi, lub je�eli posiadasz swoje w�asne - pozostawi� je.
         Je�eli nie jeste� pewien co wybra�, bezpieczniej b�dzie je�eli pozostawisz swoje ustawienia a nast�pnie z poziomu okna 
         konfiguracji wtyczki wybierzesz opcj� "Przywr�� domy�lne ustawienia".<br>
         Co zrobi� z bie��cymi ustawieniami wytyczki do pobierania notowa� GPW?
         <br><br>
         <div style="padding-left: 40px">
           <input type="radio" name="config" value="leave" CHECKED>Pozostaw moje ustawienia<br>
           <input type="radio" name="config" value="change">Zmie� na domy�lne ustawienia
         </div>
	</body>
</html>
