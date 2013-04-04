<%@ page import="java.io.*"%>
<%!
/**
 * Retourne le contenu d'un fichier sous la forme d'un tableau de bytes
 * 
 */
static public byte[] getBytesFromFile(File file) throws IOException
{
    InputStream is = new FileInputStream(file);

    // Get the size of the file
    long length = file.length();

    if (length > Integer.MAX_VALUE)
    {
        throw new IOException("File is too large to process");
    }

    // Create the byte array to hold the data
    byte[] bytes = new byte[(int) length];

    // Read in the bytes
    int offset = 0;
    int numRead = 0;
    while ((offset < bytes.length)
            && ((numRead = is.read(bytes, offset, bytes.length - offset)) >= 0))
    {
        offset += numRead;
    }

    // Ensure all the bytes have been read in
    if (offset < bytes.length)
    {
        throw new IOException("Could not completely read file "
                + file.getName());
    }

    is.close();
    return bytes;
}
%>
<%
String PDFfileName = this.getServletContext().getRealPath(request.getParameter("PDFfileName"));

File f = new File(PDFfileName);
if(false == f.exists()){
    // utilisé par les demo pdf signé, le pdf est en dehors de la webapp
    PDFfileName = request.getParameter("PDFfileName");
}

byte[] PDFbytes = "|-(".getBytes();
    
if(PDFfileName.endsWith(".pdf")) {
	PDFbytes = getBytesFromFile(new java.io.File(PDFfileName));
	response.setContentType("application/pdf");
}

response.setContentLength(PDFbytes.length);

ServletOutputStream sout = response.getOutputStream();
sout.write(PDFbytes, 0, PDFbytes.length);
sout.flush();
sout.close();

out.clear();
out = pageContext.pushBody();
%>