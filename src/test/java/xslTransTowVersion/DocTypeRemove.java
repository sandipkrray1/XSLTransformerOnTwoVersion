package xslTransTowVersion;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.xpath.XPathExpressionException;

import org.apache.commons.io.FileUtils;
import org.xml.sax.SAXException;

public class DocTypeRemove {
	
	/*public static void main(String[] args) throws TransformerException, SaxonApiException, XPathExpressionException, SAXException, IOException, ParserConfigurationException {
			executeOnFolder("C://sandip/QA_testing/USM_cleanup/source/input");
		}*/

	public static void executeOnFolder(String workingFolder1) throws XPathExpressionException, SAXException, IOException, ParserConfigurationException
    {
		File folderis = new File(workingFolder1);
		File[] listOfFilesis = folderis.listFiles();
		for (File fileis : listOfFilesis) {
			if (fileis.isFile() && fileis.getName().contains(".xml")){
	    		getXMLDocument(workingFolder1, fileis.getPath());
	    		
			} else if (!fileis.isFile())
			{
				System.out.println("There is no xml file at the given location.");
    	    }

		}

    }
    public static void getXMLDocument(String uri, String xmlFile) throws SAXException, IOException, ParserConfigurationException
    {
		String result = "";
		 InputStream in = new FileInputStream(xmlFile);
			InputStreamReader isr = new  InputStreamReader(in, "UTF-8");

			int numCharsRead;
			char[] charArray = new char[1024];
			StringBuffer sb = new StringBuffer();
			while ((numCharsRead = isr.read(charArray)) > 0) {
				sb.append(charArray, 0, numCharsRead);
			}
			result = sb.toString();
			result =result.replaceAll("<!DOCTYPE((.|\n|\r)*?)\">", "");
            File newFile = new File(xmlFile);
            
            System.out.println("Doctype is deleted from the file: "+newFile);
			if(!newFile.exists() && !result.equals(""))
			{
				FileUtils.writeStringToFile(newFile, result, "UTF-8");
			}
			else
			{
				newFile.delete();
				FileUtils.writeStringToFile(newFile, result, "UTF-8");
			}
    }

}