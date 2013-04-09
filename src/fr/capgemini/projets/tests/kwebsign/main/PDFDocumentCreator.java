/**
 * 
 */
package fr.capgemini.projets.tests.kwebsign.main;

import java.io.FileOutputStream;
import java.io.IOException;

import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfAnnotation;
import com.lowagie.text.pdf.PdfFormField;
import com.lowagie.text.pdf.PdfName;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.PdfStamper;
import com.lowagie.text.pdf.PdfString;
import com.lowagie.text.pdf.PdfWriter;

import fr.capgemini.projets.tests.kwebsign.model.ShowInputDialog;

/**
 * @author dtadmi
 * 
 */
public class PDFDocumentCreator
{

	public static final String RESULT = "D:/Users/dtadmi/Documents/DEVELOPPEMENT/iText/iText_tests/tests/hello.pdf";
	
	/**
	 * 
	 */
	public PDFDocumentCreator()
	{

		super();
		// TODO Auto-generated constructor stub
	}	

	public String createPDFDocToSign() throws DocumentException, IOException
	{

		Rectangle pagesize = new Rectangle(216f, 720f);
		Document document = new Document(pagesize, 36f, 72f, 108f, 180f);

		PdfWriter.getInstance(document, new FileOutputStream(RESULT));
		document.open();
		document.add(new Paragraph("Hello World!"));
		document.close();

		String title = "Dimensions de la zone de signature";
		// String label = "Entrez les paramètres de la zone de signature";
		ShowInputDialog sid = new ShowInputDialog(title);
		sid.defineParametersInterface();

		do
		{
		}
		while (sid.getFrame().isShowing());

		String outFile = RESULT.substring(0, RESULT.lastIndexOf(".")) + "_out.pdf";
		
		try
		{
			PdfReader pdf = new PdfReader(RESULT);
			PdfStamper stp = new PdfStamper(pdf, new FileOutputStream( outFile
					/*RESULT.substring(0, RESULT.lastIndexOf("/")) + "/out.pdf"*/));
			PdfFormField sig = PdfFormField.createSignature(stp.getWriter());
			sig.setWidget(new Rectangle(sid.getX(), sid.getY(), sid.getWidth(),
					sid.getHeight()), null);
			sig.setFlags(PdfAnnotation.FLAGS_PRINT);
			sig.put(PdfName.DA, new PdfString("/Helv 0 Tf 0 g"));
			sig.setFieldName("Signature1");
			sig.setPage(1);
			stp.addAnnotation(sig, 1);
			stp.close();
		}
		catch (Exception e)
		{
			e.printStackTrace();
			System.out.println(e.getMessage());
		}
		
		return outFile;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) throws DocumentException,
			IOException
	{
		PDFDocumentCreator hw = new PDFDocumentCreator();
		System.out.println(hw.createPDFDocToSign());

	}

}
