<%@ page import="com.dictao.keynectis.quicksign.transid.*"%>
<%@ page import="java.io.*"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.apache.commons.logging.impl.Log4JLogger"%>

<%!
public Logger log5 = Logger.getLogger("demo6p5.jsp");
%>

<%
	log5.info("demo6p5.jsp: Début _ page de retour _ réponse du portail https://keynectis.kwebsign.net/QS/Page1V2 \n");	
%>

<%
String hashBase64 = (String)session.getAttribute("hashBase64");
session.removeAttribute("hashBase64");
log5.info("demo6p5.jsp: récupération et suppression du hashBase64/"+ hashBase64+ " en attribut de session. \n");
log5.info("demo6p5.jsp: récupération des fichier pdf de sortie, transnum, et status en paramètres de requête. La page affichée dépend désormais du status. Retour sur p1.jsp en cas de succès \n");
    String pdfOutPath = request.getParameter("pdfOutPath");
    String transNum = request.getParameter("transNum");
	String status = request.getParameter("status");
	if (status.equals("1"))
	{
%>
<html>
<head>
	<title>K.Websign</title>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<meta Http-Equiv="Cache-Control" Content="no-cache">
	<meta Http-Equiv="Pragma" Content="no-cache">
	<meta Http-Equiv="Expires" Content="0">
	<link rel="stylesheet" href="../css/style.css" type="text/css">
<script>
  function Valider()
  {
	  document.mainForm.submit();
  }
  function Annuler()
  {
    location.replace("demo6p1.jsp");
  }
  </script>
</head>
<body class="contenu" style="margin:0px;padding:0px;background-color:black;overflow-y:hidden;margin-right: 5px"  >

<table align="center" width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" style="background-color:black; margin:0px;padding:0px">
	<tr>
		<td width="10%" align="center" rowspan="6" class="Arial11Bold" valign="middle" style="color:white">
			<img src="../img/signature_contrat_electronique.gif">
			<br>
			<b>Document original</b>
		</td>
		<td width="10%" align="center" rowspan="6" valign="middle">
			<img src="../img/flecheDroite.jpg">
		</td>
	</tr>
	<tr height="50px">
		<td width="100%" align="center" nowrap class="tdTitre" style="color:white">
		Etape 3 - Compte-rendu
		</td>
	</tr>
	<tr>
		<td align="center" height="100%">
			<iframe width="100%" height="100%" src="../showPDF.jsp?PDFfileName=<%=pdfOutPath%>" frameborder="0"></iframe>
		</td>
	</tr>
	<tr style="background-color:white">
		<td align="center">
			<input type="button" class="AllButton" onclick="window.open('../showPDF.jsp?PDFfileName=<%=pdfOutPath%>');" value="Voir">
		</td>
	</tr>
	<tr style="background-color:white">
		<td align="center">
			<div style="margin:10">
				<span class="Arial11Bold">Nous avons enregistr&eacute; et archiv&eacute; chez un tiers<br>
				le document ci-dessus que vous avez sign&eacute;.
				<br>Ce document est non modifiable.
				</span>
				<br>
				<br>
				<span class="Arial11Bold">Merci de votre confiance.</span>
				<br>
				<br>
				<button class="AllButton" onClick="location.href='demo6p1.jsp'">Recommen&ccedil;ons</button>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
<%
}
else
{
%>
<html>

<head>
<title>K.Websign</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
<link rel="stylesheet" href="../css/style.css" type="text/css">
</head>

<body class="contenu">
<table align="center">
	<tr>
		<td class="tdTitre">
			<div align="center">
<!-- 
			<img src="../img/K.Websign.gif">
-->
			<br>
			Etape 3 - Compte-rendu
			<br>
			<br>
			<span class="Arial11Bold">Votre signature de contrat, sous le n&deg; <%=transNum%>,
			a &eacute;chou&eacute; (code erreur : <%=status%>).</span>
			<br>
			<br>
			<button class="AllButton"
				onClick="location.href='demo6p1.jsp'">Recommen&ccedil;ons</button>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
<%

}
%>
