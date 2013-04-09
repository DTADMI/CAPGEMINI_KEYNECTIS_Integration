<%@ page import="com.dictao.keynectis.quicksign.transid.*"%>
<%@ page import="java.io.*"%>
<%@page import="java.util.logging.Logger"%>
<%@page import="org.apache.commons.logging.impl.Log4JLogger"%>

<%!
public Logger log4 = Logger.getLogger("demo6p4.jsp");
%>

<%
	log4.info("demo6p4.jsp: D�but _ G�n�ration de la r�ponse du portail https://keynectis.kwebsign.net/QS/Page1V2\n");
%>

<%
	String transNumInSession = (String)session.getAttribute("transNum");
	String pdfOutPath = this.getServletContext().getRealPath((String)session.getAttribute("OUT")).concat("/"+transNumInSession+".pdf");

	log4.info("demo6p4.jsp: R�cup�ration du transNum en session: " + transNumInSession + "; et nom du fichier pdf de sorie � partir de transnum: " + pdfOutPath+"\n");
	
	FileOutputStream fos = new FileOutputStream(pdfOutPath);
	String blob = request.getParameter("blob");
	ResponseTransId rti = new ResponseTransId();
	rti.setB64Blob(blob);
	rti.setCipherCertFilePath(this.getServletContext().getRealPath((String)session.getAttribute("CERT"))+ "/demoqs_c.p12", "DemoQS");
	//rti.setExtractDir("/home/quicksign/simulclient/demoqs/tmp");
	rti.setOutputStream(fos);
	String transNum = rti.getTransNum();
	int status = rti.getStatus();
	fos.close();

	log4.info("demo6p4.jsp: R�cup�ration du blob en attribut de requ�te: "+blob+", et cr�ation d'un nouvel rti; attribution du blob au rti, d�finition du certificat de signature du blob retour demoqs_c.p12, ainsi que de son mdp DemoQS\n");
	log4.info("demo6p4.jsp: Le blob r�ponse est donc sign� de nouveau. On r�cup�re �galement le statut de la rti: " +status+ ", (1=succ�s, sinon �chec) et on ferme le fichier pdf g�n�r�, ouvert pour pouvoir lire dedans et l'affecter au rti.\n");
	
	String subDirectory = request.getServletPath().substring(1,request.getServletPath().lastIndexOf("/"));
	String url = "../index.jsp?pageDemo="+subDirectory+"/demo6p5.jsp&transNum="+transNum+"&status="+status+"&pdfOutPath="+((String)session.getAttribute("OUT")).concat("/"+transNumInSession+".pdf");
	
	response.sendRedirect(url);
	
	log4.info("demo6p4.jsp: Construction de l'url d'affichage de la r�ponse, et envoi de cette derni�re � cette url. Il s'agit en fait de la jsp demo6p5.jsp\n");
%>
