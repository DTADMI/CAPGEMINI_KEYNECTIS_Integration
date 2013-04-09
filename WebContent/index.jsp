<%@page import="java.util.logging.Logger"%>
<%@page import="org.apache.commons.logging.impl.Log4JLogger"%>

<%!
private Logger log = Logger.getLogger("index.jsp");
%>

<%

session.setAttribute("isLogged", new Object());

String pageDemo = request.getParameter("pageDemo");
String soc = null;

if ((pageDemo != null)
		&& (pageDemo.endsWith("p5.jsp"))) {
	// on revient de demo?p5.jsp donc getParameter(soc) vaut null => on obtient la valeur en session
			
	soc = (String) session.getAttribute("soc");

	String transNum = request.getParameter("transNum");
	String status = request.getParameter("status");
	String pdfOutPath = request.getParameter("pdfOutPath");

	pageDemo += "?transNum=" + transNum + "&status=" + status + "&pdfOutPath=" + pdfOutPath;
} 
else 
{
	log.info("index.jsp: Début de la démo _ Page principale encadrant tout le reste\n");
	soc = request.getParameter("soc");
	log.info("index.jsp _ ligne 30: Instanciation de la variable String soc par récupération du paramètre soc de la requête\n");
	log.info("index.jsp: Variable soc = "+ soc+"\n");
	

	if(soc==null) 
	{
		// apres clic sur goHome()
		log.info("index.jsp: soc = null car première ouverture de la page\n");
		soc = (String) session.getAttribute("soc");
		log.info("index.jsp _ ligne 39: Instanciation de la variable String soc par récupération de l'attribut soc de la session \n");
		log.info("index.jsp: Variable soc = "+ soc);
	} 
	else 
	{
		// on met en session pour reutilisation lorsqu'on repassera par cette page apres la page 4
		log.info("index.jsp: soc!=null car retour sur la page\n");
		log.info("index.jsp _ ligne 48: Mise en session de la variable soc pour récupération de l'attribut lorsqu'on repassera par cette page après la 4 \n");
		session.setAttribute("soc", soc);
		log.info("index.jsp: Variable soc = " + soc + "\n");
	}
}
%>
<html>
<head>
<title>D&eacute;monstration K.Websign</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta Http-Equiv="Cache-Control" Content="no-cache">
<meta Http-Equiv="Pragma" Content="no-cache">
<meta Http-Equiv="Expires" Content="0">
<link rel="stylesheet" href="css/template-style.css" type="text/css">
</head>
<body style="background-color:white;margin:0px" onkeydown="if( event.keyCode == 120 ) goDemoPDF();">
<TABLE WIDTH="1000px" align="center" CELLPADDING="0" CELLSPACING="0" style="border: 1px rgb(204, 232, 58) solid">
<TR style="background-color:gray">
	<TD>
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr style="background-color:gray">
			<td valign="middle" align="center"><IMG SRC="img/interne.gif"></td>
			<td valign="middle" align="center"><span class="nomSoc" >PORTAIL DE DEMONSTRATION</span></td>
			<td valign="middle" align="right" width="100%"><IMG SRC="img/mosaic.header.jpg"></td>
		</tr>
		</table>
	</TD>
</TR>
<TR>
</TR>
	<TR id="iframeTR" style="background-color:white">
		<TD height="650px" id="iframeTD">
			<iframe id="theIframe" style="margin:0" src="demoPDFSMS/demo6p1.jsp" width="100%" height="100%" frameborder="0"></iframe>
		</TD>
	</TR>
	<tr style="background-color:black;" height="40px">
		<td class="style2" align="right">
			<script>document.write("&copy; " + new Date().getFullYear() + " <%=soc%>.");</script>
		</td>
	</tr>
</TABLE>
<script>
function goHome()
{
	location.href="cadre.jsp";
	<%
		log.info("index.jsp _ ligne 91: fonction goHome() - Référencement à cadre.jsp\n");
	%>
}
</script>
<%
if (pageDemo != null)
{
%>
<script>
document.getElementById("theIframe").src="<%=pageDemo%>";
</script>
<%
}
%>
</body>
</html>
