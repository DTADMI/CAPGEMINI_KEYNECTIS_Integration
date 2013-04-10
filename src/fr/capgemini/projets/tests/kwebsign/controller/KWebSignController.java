package fr.capgemini.projets.tests.kwebsign.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class KWebSignController
 */
@WebServlet(
		description = "Interface de commande et paramétrage du test du lit KWebSign",
		urlPatterns = { "/KWebSignController" })
public class KWebSignController extends HttpServlet
{

	private static final long serialVersionUID = 1L;

	/**
	 * Default constructor.
	 */
	public KWebSignController()
	{

		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException
	{

		// TODO Auto-generated method stub
		this.getServletContext().getRequestDispatcher( "/index.jsp" ).forward( request, response );
		
		//BufferedImage bimage = ImageIO.read(new File(""));
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException
	{

		// TODO Auto-generated method stub
	}

}
