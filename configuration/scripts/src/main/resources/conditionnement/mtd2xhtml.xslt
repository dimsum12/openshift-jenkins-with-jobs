<html xsl:version="2.0"
      xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
      xmlns="http://www.w3.org/1999/xhtml"
      xsl:exclude-result-prefixes="#all"
xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:fn="http://www.w3.org/2005/xpath-functions"
>
<!-- Transform -s:fic.xml -o:fic.html -xsl:http://apollo.ign.fr/metadata/mtd2xhtml.xslt \!omit-xml-declaration=yes \!encoding=utf-8-->
<head>
<title>
	<xsl:choose>
		<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
			métadonnées de produit <xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</xsl:when>
		<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
			métadonnées de lot <xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</xsl:when>
		<xsl:otherwise>
			métadonnées de <xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
		</xsl:otherwise>
	</xsl:choose>
</title>

<style>
	* {
		font-family:Arial, sans-serif;}

	.découverte {
		color:#3366FF;}

	.essentielle {
		color:#339966}

	.spécifique {
		color:#FF9900;}

	.mtd_mtd {
		background:#FF9900;}

	.mtd {
		background:#FF6600;}

	.gauche {
		width:40%;}

	.droite {
		width:60%;}

	p, a, ul, h1, h2, h3, h4, h5, dl {
		margin-bottom:0;
		margin-top:0;}

	p, a, ul, h4, h5, dl {
		font-size:10.0pt;
		text-align:left;}

	h1, h2 {
		font-size:14.0pt;}

	h3 {
		font-size:16.0pt;}

	h1, h2, h3 {
		text-align:center;}

	h1, h2, h3, h4, h5, dt {
		font-weight:bold;}

	a, a:hover {
		color:black;}

	dd {
		text-align:justify;
		margin-left:0;}

	table {
		margin-top:10px;
		margin-bottom:10px;
		width:100%;
		border-collapse:collapse;
		table-layout:auto;}

	td {
		width:100%;
		border:solid;
		border-width:1px;
		border-color:black;
		padding:0cm 5.4pt 0cm 5.4pt;
		vertical-align:top;}

	div.découverte h5, dl.découverte dt {
		color:navy;}

	div.essentielle h5, dl.essentielle dt {
		color:green;}

	div.spécifique h5, dl.spécifique dt {
		color:#FF9900;}

	ul, li {
		margin-left:0;
		padding-left:0;
		list-style: none outside;}

	td.gauche ul ul li {
		font-style:italic;
		list-style: square inside;}

	td.droite ul ul li {
		list-style: none outside;}

	#tab_mtd_mtd ,#tab_mtd  {
		margin-bottom:20px;}
</style>

<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>

<body lang='FR'>
<xsl:variable name="NR" select="'non renseigné'"/>
<h1>
	<xsl:variable name="chaine" select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>
	<xsl:choose>
		<xsl:when test="fn:contains($chaine,'®')">
			<xsl:variable name="titre1" select="fn:substring-before($chaine,'®')"/>
			<xsl:variable name="titre2" select="fn:substring-after($chaine,'®')"/>
			<xsl:value-of select="$titre1"/><sup>&#174;</sup><xsl:value-of select="$titre2"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$chaine"/>
		</xsl:otherwise>
	</xsl:choose>

</h1>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<div id="tab_mtd_mtd"> <!--première section métadonnées sur les métadonées, un tableau-->
	<table>
		<tr>
			<td class='mtd_mtd' colspan='2'>
				<h2>
					M&#233;tadonn&#233;es sur les m&#233;tadonn&#233;es
				</h2>
			</td>
		</tr>
		<tr>
			<td class='mtd_mtd' colspan='2'>
				<h4>
					Informations sur les m&#233;tadonn&#233;es
				</h4>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Point&#160;de&#160;contact&#160;sur&#160;les&#160;m&#233;tadonn&#233;es&#160;:
					</h5>
					<ul>
					<xsl:for-each select="gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty">
						<li>&#x96; Organisation</li>
							<ul>
								<li >Nom</li>
								<li >M&#233;l</li>
							</ul>
						<li>&#x96; R&#244;le</li>
					</xsl:for-each>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<xsl:for-each select="gmd:MD_Metadata/gmd:contact/gmd:CI_ResponsibleParty">
						<xsl:variable name="email" select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
						
							<ul>
							
								<li>&#160;</li>
									<ul>
										<li ><xsl:value-of select="./gmd:organisationName/gco:CharacterString"/>&#160;</li>
										<li ><a href="mailto:{$email}"><xsl:value-of select="$email"/>&#160;</a></li>
									</ul>
								<li><xsl:value-of select="./gmd:role/gmd:CI_RoleCode"/></li>
							
							</ul>
						
					</xsl:for-each>
				</div>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Date des m&#233;tadonn&#233;es
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:dateStamp/gco:Date"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Langue des m&#233;tadonn&#233;es
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:language/gmd:LanguageCode"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Jeu de caract&#232;res des m&#233;tadonn&#233;es
					</h5>
				</div>

			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:characterSet/gmd:MD_CharacterSetCode"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Indicateur du fichier de m&#233;tadonn&#233;es
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="/gmd:MD_Metadata/gmd:fileIdentifier/gco:CharacterString"/>
				</p>
			</td>
		</tr>
	</table>
</div>
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
<div id="tab_mtd"> <!--deuxième section métadonnées, plusieurs tableaux-->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h3>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						M&#233;tadonn&#233;es de produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						M&#233;tadonn&#233;es de lot
					</xsl:when>
					<xsl:otherwise>
						M&#233;tadonn&#233;es
					</xsl:otherwise>
				</xsl:choose>
				</h3>
			</td>
		</tr>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Identification du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Identification du lot
					</xsl:when>
					<xsl:otherwise>
						Identification
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Titre de la ressource
					</h5>
				</div>
				<div class="essentielle">
					<h5>
						Autres titres
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString"/>&#160;
				</p>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle">
						<p><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:alternateTitle/gco:CharacterString"/></p>
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:value-of select="$NR"/></p>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						R&#233;sum&#233; de la ressource
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:abstract/gco:CharacterString"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Etat de la ressource
					</h5>
				</div>
			</td>
			<td class='droite'>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode">
						<ul>
						<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:status/gmd:MD_ProgressCode">
							<li><xsl:value-of select="."/></li>
						</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<p><xsl:value-of select="$NR"/></p>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Type de repr&#233;sentation spatiale
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType/gmd:MD_SpatialRepresentationTypeCode"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Type de la ressource
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode"/>
				</p>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Nom du niveau hi&#233;rarchique
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:hierarchyLevelName/gco:CharacterString"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Identifiant&#160;de&#160;la&#160;ressource
					</h5>
					<ul>
						<li>&#x96; code</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<h5>&#160;</h5>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:identifier/gmd:MD_Identifier/gmd:code/gco:CharacterString"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Langue de la ressource
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:language/gmd:LanguageCode"/>
				</p>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Cat&#233;gorie du sujet
					</h5>
				</div>
			</td>
			<td class='droite'>
				<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:topicCategory">
					<p>
						<xsl:value-of select="./gmd:MD_TopicCategoryCode"/>
					</p>
				</xsl:for-each>
			</td>
		</tr>

		<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:descriptiveKeywords">
		<tr>
			<td class='gauche'>
				<div class='découverte'>
					<h5>
						Ensemble&#160;de&#160;mots-cl&#233;s&#160;:
					</h5>
					<ul>
						<xsl:for-each select="./gmd:MD_Keywords/gmd:keyword">
							<li>&#x96; Mot-cl&#233; (<xsl:value-of select="position()"/>)</li>
						</xsl:for-each>

					<li>&#x96; Type&#160;de&#160;mots-cl&#233;s</li>
					<li>&#x96; Citation&#160;du&#160;th&#233;saurus&#160;:</li>
					<ul>
						<li>Titre&#160;du&#160;th&#233;saurus&#160;utilisé</li>
						<li>Date&#160;de&#160;cr&#233;ation</li>
						<li>Edition</li>
					</ul>
					</ul>
				</div>
			</td>

			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
						<xsl:for-each select="./gmd:MD_Keywords/gmd:keyword">
							<li><xsl:value-of select="./gco:CharacterString"/></li>
						</xsl:for-each>

						<xsl:choose>
							<xsl:when test="./gmd:MD_Keywords/gmd:type">
								<li><xsl:value-of select="./gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode"/></li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>

						<li>&#160;</li><!--passe une ligne-->

						<ul>
						<xsl:choose>
							<xsl:when test="./gmd:MD_Keywords/gmd:thesaurusName">
								<li><xsl:value-of select="./gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:title/gco:CharacterString"/>&#160;</li>
								<li><xsl:value-of select="./gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:date//gco:Date"/>&#160;</li>
								<xsl:choose>
								<xsl:when test="./gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:edition">
									<li><xsl:value-of select="./gmd:MD_Keywords/gmd:thesaurusName/gmd:CI_Citation/gmd:edition/gco:CharacterString"/></li>
								</xsl:when>
								<xsl:otherwise>
									<li><xsl:value-of select="$NR"/></li>
								</xsl:otherwise>
							</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
								<li><xsl:value-of select="$NR"/></li>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>
						</ul>
					</ul>
				</div>
			</td>
		</tr>
	</xsl:for-each>

		<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:extent[gmd:EX_Extent/gmd:geographicElement]">
		<tr>
			<td class='gauche'>
				<div class='découverte'>
					<h5>
						Etendue&#160;g&#233;ographique (<xsl:value-of select="position()"/>)&#160;:
					</h5>
					<ul>
						<li>&#x96; Rectangle&#160;englobant&#160;:</li>
						<ul>
							<li>Longitude&#160;Ouest</li>
							<li>Longitude&#160;Est</li>
							<li>Latitude&#160;Sud</li>
							<li>Latitude&#160;Nord</li>
						</ul>
						<li>&#x96; Libell&#233;</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
						<li>&#160;</li>
						<ul>
							<li><xsl:value-of select=".//gmd:westBoundLongitude/gco:Decimal"/>&#160;</li>
							<li><xsl:value-of select=".//gmd:eastBoundLongitude/gco:Decimal"/>&#160;</li>
							<li><xsl:value-of select=".//gmd:southBoundLatitude/gco:Decimal"/>&#160;</li>
							<li><xsl:value-of select=".//gmd:northBoundLatitude/gco:Decimal"/>&#160;</li>
						</ul>
						<xsl:choose>
							<xsl:when test=".//gmd:description/gco:CharacterString">
								<li><xsl:value-of select=".//gmd:description/gco:CharacterString"/></li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>
		</xsl:for-each>

		<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:extent[gmd:EX_Extent/gmd:temporalElement]">
		<tr>
			<td class='gauche'>
				<div class='découverte'>
					<h5>
						Etendue&#160;temporelle (<xsl:value-of select="position()"/>)&#160;:
					</h5>
					<ul>
						<li>&#x96; Bornes&#160;englobantes&#160;:</li>
						<ul>
							<li>Date&#160;la&#160;plus&#160;ancienne</li>
							<li>Date&#160;la&#160;plus&#160;r&#233;cente</li>
						</ul>
						<li>&#x96; Libell&#233;</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
						<li>&#160;</li>
						<ul>
						<xsl:choose>
							<xsl:when test=".//gmd:EX_TemporalExtent//gml:beginPosition ne ''">
								<li><xsl:value-of select=".//gmd:EX_TemporalExtent//gml:beginPosition"/>&#160;</li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:choose>
							<xsl:when test=".//gmd:EX_TemporalExtent//gml:endPosition ne ''">
								<li><xsl:value-of select=".//gmd:EX_TemporalExtent//gml:endPosition"/>&#160;</li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>
						</ul>
						<xsl:choose>
							<xsl:when test=".//gmd:description/gco:CharacterString">
								<li><xsl:value-of select=".//gmd:description/gco:CharacterString"/></li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="$NR"/></li>
							</xsl:otherwise>
						</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>
		</xsl:for-each>


		<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:date">
		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Date&#160;de&#160;r&#233;f&#233;rence&#160;:
					</h5>
					<ul>
						<li>&#x96; Date</li>
						<li>&#x96; Type&#160;de&#160;date</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
						<li><xsl:value-of select=".//gco:Date"/>&#160;</li>
						<li><xsl:value-of select=".//gmd:dateType"/></li>
					</ul>
				</div>
			</td>
		</tr>
		</xsl:for-each>


		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Edition&#160;des&#160;donn&#233;es&#160;d&#180;origine:
					</h5>
					<ul>
						<li>&#x96; Edition</li>
						<li>&#x96; Date</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
						<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:edition"/>&#160;</li>
						<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:citation/gmd:CI_Citation/gmd:editionDate"/></li>
					</ul>
				</div>
			</td>
		</tr>


<!--		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Extension&#160;temporelle&#160;:
					</h5>
					<ul>
						<li>&#x96; D&#233;but</li>
						<li>&#x96; Fin</li>
					</ul>
				</div>
			</td>

			<td class='droite'>
				<div>
					<h5>&#160;</h5>

					<ul>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:extent//gmd:temporalElement">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:extent//gmd:temporalElement//gml:beginPosition"/></li>
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/child::node()/gmd:extent//gmd:temporalElement//gml:endPosition"/></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>-->


		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						R&#233;solution&#160;spatiale&#160;:
					</h5>
					<ul>
						<li>&#x96; Echelle &#233;quivalente</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<xsl:if test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer">
						<ul>
						<li><xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialResolution/gmd:MD_Resolution/gmd:equivalentScale/gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer">
							1:<xsl:value-of select="."/>&#160;&#160;
						</xsl:for-each></li>
						</ul>
					</xsl:if>
				</div>
			</td>
		</tr>


		<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:pointOfContact/gmd:CI_ResponsibleParty">
			<tr>
				<td class='gauche'>
					<div class="découverte">
						<h5>
							Organisation&#160;responsable&#160;de&#160;la&#160;ressource&#160;:
						</h5>
						<ul>
							<li>&#x96; Organisation</li>
							<ul>
								<li>Nom</li>
								<li>M&#233;l</li>
							</ul>
							<li>&#x96; R&#244;le</li>
						</ul>
					</div>
				</td>
				<td class='droite'>
					<xsl:variable name="email2" select="./gmd:contactInfo/gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
					<div>
						<h5>&#160;</h5>
						<ul>
							<li>&#160;</li>
							<ul>
								<li><xsl:value-of select="./gmd:organisationName/gco:CharacterString"/>&#160;</li>
								<li><a href="mailto:{$email2}"><xsl:value-of select="$email2"/>&#160;</a></li>
							</ul>
							<li><xsl:value-of select="./gmd:role/gmd:CI_RoleCode"/></li>
						</ul>
					</div>
				</td>
			</tr>
		</xsl:for-each>

	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Informations de distribution du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Informations de distribution du lot
					</xsl:when>
					<xsl:otherwise>
						Informations de distribution
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Localisateur de la ressource
					</h5>
				</div>
			</td>
			<td class='droite'>
				<xsl:for-each-group select="gmd:MD_Metadata/gmd:distributionInfo/child::node()/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource/gmd:linkage/gmd:URL" group-by=".">
					<xsl:variable name="ref" select="."/>
					<xsl:choose>
						<xsl:when test="fn:not(fn:contains($ref,'http://'))">
							<p><xsl:value-of select="$ref"/></p>
						</xsl:when>
						<xsl:otherwise>
							<a href="{$ref}"><xsl:value-of select="$ref"/></a><p/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each-group>
			</td>
		</tr>

		<xsl:for-each select="gmd:MD_Metadata/gmd:distributionInfo/child::node()/gmd:distributionFormat">
			<tr>
				<td class='gauche'>
					<div class='essentielle'>
						<h5>
							Format&#160;de&#160;distribution&#160;des&#160;donn&#233;es(<xsl:value-of select="position()"/>)
						</h5>
						<ul>
							<li>&#x96; Nom</li>
							<li>&#x96; Version</li>
						</ul>
					</div>
				</td>
				<td class='droite'>
					<div>
						<h5>&#160;</h5>
						<ul>
							<li><xsl:value-of select="fn:substring-after(./gmd:MD_Format/@id,'distributionFormat.')"/>&#160;</li>
							<li><xsl:value-of select="./gmd:MD_Format/gmd:version/gco:CharacterString"/></li>
						</ul>
					</div>
				</td>
			</tr>
		</xsl:for-each>

		<xsl:for-each select="gmd:MD_Metadata/gmd:distributionInfo/child::node()/gmd:distributor">
			<tr>
				<td class='gauche'>
					<div class='essentielle'>
						<h5>
							Distributeur&#160;de&#160;la&#160;ressource&#160;:
						</h5>
						<ul>
							<li>&#x96; Nom</li>
							<li>&#x96; adresse&#160;mail</li>
							<li>&#x96; r&#244;le&#160;jou&#233;</li>
						</ul>
					</div>
				</td>
				<td class='droite'>
					<xsl:variable name="email3" select=".//gmd:CI_Contact/gmd:address/gmd:CI_Address/gmd:electronicMailAddress/gco:CharacterString"/>
					<div>
						<h5>&#160;</h5>
						<ul>
							<li><xsl:value-of select=".//gmd:organisationName/gco:CharacterString"/>&#160;</li>
							<li><a href="mailto:{$email3}"><xsl:value-of select="$email3"/>&#160;</a></li>
							<li><xsl:value-of select=".//gmd:role/gmd:CI_RoleCode"/></li>
						</ul>
					</div>
				</td>
			</tr>
		</xsl:for-each>
	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Informations sur la qualit&#233; du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Informations sur la qualit&#233; du lot
					</xsl:when>
					<xsl:otherwise>
						Informations sur la qualit&#233;
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>

		<tr>
			<td class='gauche'>
				<div class="découverte">
					<h5>
						Relev&#233; g&#233;n&#233;alogique de la ressource
					</h5>
				</div>
			</td>

			<td class='droite'>
				<xsl:for-each select="gmd:MD_Metadata/gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage">
					<p><xsl:value-of select="./gmd:LI_Lineage/gmd:statement/gco:CharacterString"/>
				</p></xsl:for-each>
			</td>
		</tr>
		<!-- 	découpage en 2 cellules sans bords pour éviter les décalages car le 1er § peut-etre très long -->
		<tr>
			<td class='gauche' style="border-bottom:none">
				<div class='spécifique'>
					<h5>
						Source&#160;de&#160;la&#160;ressource
					</h5>
					<ul>
						<li>&#x96; Description</li>
					</ul>
				</div>
			</td>

			<td class='droite' style="border-bottom:none">
				<div>
					<h5>&#160;</h5>
					<ul>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:dataQualityInfo//gmd:source/gmd:LI_Source/gmd:description">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:dataQualityInfo//gmd:source/gmd:LI_Source/gmd:description/gco:CharacterString"/>&#160;</li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>
		<tr>
			<td class='gauche' style="border-top:none">
				<div class='spécifique'>
					<ul>
						<li>&#x96; Echelle</li>
					</ul>
				</div>
			</td>
			<td class='droite' style="border-top:none">
				<div>
					<ul>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:dataQualityInfo//gmd:source/gmd:LI_Source/gmd:scaleDenominator//gco:Integer">
							<li><xsl:for-each select="gmd:MD_Metadata/gmd:dataQualityInfo//gmd:source/gmd:LI_Source/gmd:scaleDenominator//gco:Integer">
								1:<xsl:value-of select="."/>&#160;&#160;
							</xsl:for-each></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>
	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<table>
		<tr>
		<td class='mtd' colspan='2'>
			<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Contraintes d&#180;acc&#232;s et d&#180;utilisation du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Contraintes d&#180;acc&#233;s et d&#180;utilisation du lot
					</xsl:when>
					<xsl:otherwise>
						Contraintes d&#180;acc&#233;s et d&#180;utilisation
					</xsl:otherwise>
				</xsl:choose>
			</h4>
		</td>
		</tr>


		<tr>
			<td class='gauche'>
				<div class='découverte'>
					<h5>
						Contraintes&#160;l&#233;gales&#160;:
					</h5>
					<ul>
						<li>&#x96; Limitation</li>
						<li>&#x96; Contrainte&#160;d&#180;acc&#232;s</li>
						<li>&#x96; Contrainte&#160;d&#180;usage</li>
					</ul>
				</div>
			</td>
			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_Constraints/gmd:useLimitation/gco:CharacterString"/></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:accessConstraints/gmd:MD_RestrictionCode"/></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:useConstraints/gmd:MD_RestrictionCode"/></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>


		<tr>
		<td class='gauche'>
			<div class='découverte'>
				<h5>
					Contraintes&#160;de&#160;s&#233;curit&#233;&#160;:
				</h5>
				<ul>
					<li>&#x96; Limitation</li>
					<li>&#x96; Niveau&#160;de&#160;classification</li>
				</ul>
			</div>
		</td>
		<td class='droite'>
			<div>
				<h5>&#160;</h5>
				<ul>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_SecurityConstraints">
						<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:useLimitation/gco:CharacterString"/>&#160;</li>
						<li><xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceConstraints/gmd:MD_SecurityConstraints/gmd:classification/gmd:MD_ClassificationCode"/></li>
					</xsl:when>
					<xsl:otherwise>
						<li><xsl:value-of select="$NR"/></li>
						<li><xsl:value-of select="$NR"/></li>
					</xsl:otherwise>
				</xsl:choose>
				</ul>
			</div>
		</td>
		</tr>
	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Informations de maintenance du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Informations de maintenance du lot
					</xsl:when>
					<xsl:otherwise>
						Informations de maintenance
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Fr&#233;quence de mise &#224; jour
					</h5>
				</div>
			</td>
			<td class='droite'>
				<p>
					<xsl:value-of select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance//gmd:MD_MaintenanceFrequencyCode"/>
				</p>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Note sur la maintenance
					</h5>
				</div>
			</td>
			<td class='droite'>
				<ul>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance//gmd:maintenanceNote">
						<xsl:for-each select="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceMaintenance//gmd:maintenanceNote">
							<li><xsl:value-of select="./gco:CharacterString"/></li>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<li><xsl:value-of select="$NR"/></li>
					</xsl:otherwise>
				</xsl:choose>
				</ul>
			</td>
		</tr>
	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Informations sur les syst&#232;mes de r&#233;f&#233;rence du produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Informations sur les syst&#232;mes de r&#233;f&#233;rence du lot
					</xsl:when>
					<xsl:otherwise>
						Informations sur les syst&#232;mes de r&#233;f&#233;rence
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>

		<xsl:for-each select="gmd:MD_Metadata/gmd:referenceSystemInfo">
			<tr>
				<td class='gauche'>
					<div class='essentielle'>
						<h5>
							Informations&#160;sur&#160;le&#160;syst&#232;me&#160;de&#160;r&#233;f&#233;rence&#160;(<xsl:value-of select="position()"/>)
						</h5>
						<ul>
							<li>&#x96; Code</li>
							<ul>
								<li>href</li>
							</ul>
							<li>&#x96; Espace de nommage</li>
						</ul>
					</div>
				</td>
				<td class='droite'>
					<div>
						<h5>&#160;</h5>
						<ul>
							<li><xsl:value-of select=".//gmd:RS_Identifier/gmd:code/gmx:Anchor"/></li>
							<ul>
								<li><xsl:value-of select=".//gmd:RS_Identifier/gmd:code/gmx:Anchor/@xlink:href"/></li>
							</ul>
							<li><xsl:value-of select=".//gmd:RS_Identifier/gmd:codeSpace/gco:CharacterString"/></li>
						</ul>
					</div>
				</td>
			</tr>
		</xsl:for-each>
	</table>
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<!-- je mets de &#160; à la fin de chaque ligne d'une case à plusieurs lignes pour éviter les décalages si une valeurs absente -->
	<!-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ -->
	<xsl:if test="gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:spatialRepresentationType[gmd:MD_SpatialRepresentationTypeCode eq 'vector']">
	<!-- ne s'applique qu'aux données vectorielles -->
	<table>
		<tr>
			<td class='mtd' colspan='2'>
				<h4>
				<xsl:choose>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'series'">
						Informations sur la repr&#233;sentation&#160;spatiale&#160;du&#160;produit
					</xsl:when>
					<xsl:when test="gmd:MD_Metadata/gmd:hierarchyLevel/gmd:MD_ScopeCode eq 'dataset'">
						Informations sur la repr&#233;sentation&#160;spatiale&#160;du&#160;lot
					</xsl:when>
					<xsl:otherwise>
						Informations sur la repr&#233;sentation&#160;spatiale&#160;
					</xsl:otherwise>
				</xsl:choose>
				</h4>
			</td>
		</tr>
		<tr>
			<td class='gauche'>
				<div class="essentielle">
					<h5>
						Niveau topologique
					</h5>
					<ul>
						<li>&#x96; Code</li>
					</ul>
				</div>
			</td>

			<td class='droite'>
				<div>
					<h5>&#160;</h5>
					<ul>
					<xsl:choose>
						<xsl:when test="gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode">
							<li><xsl:value-of select="gmd:MD_Metadata/gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:topologyLevel/gmd:MD_TopologyLevelCode"/></li>
						</xsl:when>
						<xsl:otherwise>
							<li><xsl:value-of select="$NR"/></li>
						</xsl:otherwise>
					</xsl:choose>
					</ul>
				</div>
			</td>
		</tr>
	</table>
	</xsl:if>
</div>

<div id="légende">
	<dl class="découverte">
		<dt>
			M&#233;tadonn&#233;es de d&#233;couverte
		</dt>
		<dd>
			les m&#233;tadonn&#233;es de d&#233;couverte constituent les m&#233;tadonn&#233;es fondamentales en ce sens qu&#180;elles interviennent dans les m&#233;canismes de recherche et qu&#180;elles touchent intimement &#224; l&#180;identification de la ressource. Ce groupe co&#239;ncide avec la vue d&#233;couverte du profil fran&#231;ais.
		</dd>
	</dl>
	<dl class="essentielle">
		<dt>
			M&#233;tadonn&#233;es essentielles
		</dt>
		<dd>
			les m&#233;tadonn&#233;es essentielles permettent d&#180;en savoir plus sur la ressource. Ce groupe co&#239;ncide avec la vue essentielle du profil fran&#231;ais.
		</dd>
	</dl>
	<dl class="spécifique">
		<dt>
			M&#233;tadonn&#233;es sp&#233;cifiques
		</dt>
		<dd>
			les m&#233;tadonn&#233;es sp&#233;cifiques compl&#233;tent les m&#233;tadonn&#233;es de d&#233;couverte et essentielles pour r&#233;pondre &#224; des besoins exprim&#233;s par des clients de l&#180;IGN.
		</dd>
	</dl>
</div>

</body>

</html>
