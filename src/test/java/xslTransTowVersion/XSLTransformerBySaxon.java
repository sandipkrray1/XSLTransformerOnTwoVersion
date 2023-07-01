package xslTransTowVersion;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Collection;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerException;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPathExpressionException;

import org.apache.commons.io.FileUtils;
import org.xml.sax.SAXException;

import net.sf.saxon.s9api.Processor;
import net.sf.saxon.s9api.SaxonApiException;
import net.sf.saxon.s9api.Serializer;
import net.sf.saxon.s9api.XdmNode;
import net.sf.saxon.s9api.XsltCompiler;
import net.sf.saxon.s9api.XsltExecutable;
import net.sf.saxon.s9api.XsltTransformer;

public class XSLTransformerBySaxon {
	
	private static String fileName;
	static PropertyReader pr = new PropertyReader();
	public static void main(String[] args) throws TransformerException, SaxonApiException, XPathExpressionException, SAXException, IOException, ParserConfigurationException {
		try {
			if(pr.readProperty("IsDeleteDoctype").equalsIgnoreCase("yes"))
			{
				DocTypeRemove.executeOnFolder(pr.readProperty("SourceInputPath"));
				DocTypeRemove.executeOnFolder(pr.readProperty("SourceOutputPath"));
			}

			if(pr.readProperty("IsMetadaOrBody").equalsIgnoreCase("Both"))
			{
			System.out.println();
			System.out.println("***Conversion is started for With Metadata content.***");
			saxonTransform(pr.readProperty("SourceInputPath"), pr.readProperty("ResultInputPath"), pr.readProperty("XSLTWithMetaOld"));
			saxonTransform(pr.readProperty("SourceOutputPath"), pr.readProperty("ResultOutputPath"), pr.readProperty("XSLTWithMetaNew"));
			System.out.println("***Conversion is completed for With Metadata content.***");
			System.out.println();
			}
			else if(pr.readProperty("IsMetadaOrBody").equalsIgnoreCase("Body"))
			{
				System.out.println();
				System.out.println("***Conversion is started for Without Metadata content.***");
				saxonTransform(pr.readProperty("SourceInputPath"), pr.readProperty("ResultInputPath"), pr.readProperty("XSLTExceptMetaOld"));
				saxonTransform(pr.readProperty("SourceOutputPath"), pr.readProperty("ResultOutputPath"), pr.readProperty("XSLTExceptMetaNew"));
				System.out.println("***Conversion is completed for Without Metadata content.***");
			}
			else if(pr.readProperty("IsMetadaOrBody").equalsIgnoreCase("Metadata"))
			{
				System.out.println();
				System.out.println("***Conversion is started for Metadata content only.***");
				saxonTransform(pr.readProperty("SourceInputPath"), pr.readProperty("ResultInputPath"), pr.readProperty("XSLTMetaOnlyOld"));
				saxonTransform(pr.readProperty("SourceOutputPath"), pr.readProperty("ResultOutputPath"), pr.readProperty("XSLTMetaOnlyNew"));
				System.out.println("***Conversion is completed for Metadata content only.***");
			}
			else
			{
				System.out.println("Please provide 'IsMetadaOrBody' value as 'Metadata' OR 'Body', OR 'Both' in config.properties file.");
			}
			} catch (SaxonApiException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	
	public static void saxonTransform(String xmlFolder, String outputDir, String xslt) throws SaxonApiException{
	  File input = new File(xmlFolder);
      if(input.exists())
      {
          if(input.isFile())
          {
        	  saxonFilesTransform(xmlFolder, outputDir, xslt);
          }
          else if(input.isDirectory())
          {
        	  saxonMultiFolderTransform(xmlFolder, outputDir, xslt);
          }
          else
          {
              System.out.println("Input path and Output path should be folder OR file!");
          }
      }
      else
      {
          System.out.println("Input path or Output path does not exist!");
      }

	}
	
	public static void saxonFilesTransform(String xmlFolder, String outputDir, String xslt) throws SaxonApiException
	{
	  Processor proc = new Processor(false);
	  XsltCompiler comp = proc.newXsltCompiler();
	  
	  try {

		  Collection<File> files = FileUtils.listFiles(new File(xmlFolder), new String[] {"xml"}, false);//for skipping subdirectory
		  for (File file : files)
		  	{
				  
			String fName = file.getName();
			XsltExecutable exp = comp.compile(new StreamSource(new File(xslt)));
			XdmNode source = proc.newDocumentBuilder().build(new StreamSource(xmlFolder+File.separator+fName));
			Serializer out = proc.newSerializer(new File(outputDir, fName));
			out.setOutputProperty(Serializer.Property.METHOD, "xml");
			//out.setOutputProperty(Serializer.Property.INDENT, "no");
			XsltTransformer trans = exp.load();
			trans.setInitialContextNode(source);
			trans.setDestination(out);
			trans.transform();
			System.out.println("Converted: "+fName);
			}
			files.clear();
			System.out.println("XML Conversion done for the folder: "+xmlFolder);
		} catch (Exception e)
			{
			e.printStackTrace();
			System.out.println("Getting exception in: "+fileName);
			}
	  	 finally
	  		{
	  		}
		}

	public static void saxonSingleFolderTransform(String xmlFolder, String outputDir, String xslt, String subfoldername) throws SaxonApiException
	{
	  Processor proc = new Processor(false);
	  XsltCompiler comp = proc.newXsltCompiler();
	  
	  try {

		  Collection<File> files = FileUtils.listFiles(new File(xmlFolder), new String[] {"xml"}, false);//for skipping subdirectory
		  for (File file : files)
		  	{
			  if(pr.readProperty("IgnoreFiles").contains(file.getName()))
			  {
				  continue;
			  }
				  
			String fName = file.getName();
			if(pr.readProperty("SubfoldernameInFilename").contains("yes"))
			{
			fileName=subfoldername+fName;
			}
			else
				fileName=fName;
			XsltExecutable exp = comp.compile(new StreamSource(new File(xslt)));
			XdmNode source = proc.newDocumentBuilder().build(new StreamSource(xmlFolder+File.separator+fName));
			Serializer out = proc.newSerializer(new File(outputDir, fileName));
			out.setOutputProperty(Serializer.Property.METHOD, "xml");
			//out.setOutputProperty(Serializer.Property.INDENT, "no");
			XsltTransformer trans = exp.load();
			trans.setInitialContextNode(source);
			trans.setDestination(out);
			trans.transform();
			System.out.println("Converted: "+fName);
			}
			files.clear();
			System.out.println("XML Conversion done for the folder: "+xmlFolder);
		} catch (Exception e)
			{
			e.printStackTrace();
			System.out.println("Getting exception in: "+fileName);
			}
	  	 finally
	  		{
	  		}
		}

	
	public static void saxonMultiFolderTransform(String xmlFolder, String outputDir, String xslt) throws SaxonApiException
	{
		File files = new File(xmlFolder);
        for (File inputFile : files.listFiles())
        {
            /*if (!inputFile.getName().endsWith(".xml"))
            {
                continue;
            }*/
            if(inputFile.isDirectory())
            {
            	//subfolder
                for (File inputFile1 : inputFile.listFiles())
                {
                    if(inputFile1.isDirectory())
                    {
                        //version
                        for (File inputFile2 : inputFile1.listFiles())
                        {
                            if(inputFile2.isDirectory())
                            {
                            	//year
                                for (File inputFile3 : inputFile2.listFiles())
                                {
                                	if(inputFile3.isDirectory())
                                	{
                                        String subfoldern = inputFile.getName()+"_"+inputFile1.getName()+"_"+inputFile2.getName()+"_"+inputFile3.getName()+"_";
                                     	  saxonSingleFolderTransform(inputFile3.toString(), outputDir, xslt, subfoldern);
                                     	  break;
                                	}
                                	else
                                	{
                                        String subfoldern = inputFile.getName()+"_"+inputFile1.getName()+"_"+inputFile2.getName()+"_";
                                     	  saxonSingleFolderTransform(inputFile2.toString(), outputDir, xslt, subfoldern);
                                     	  break;
                                	}
                                	
                                }
                            }
                            else {
                                String subfoldern = inputFile.getName()+"_"+inputFile1.getName()+"_";
                            	  saxonSingleFolderTransform(inputFile1.toString(), outputDir, xslt, subfoldern);
                              	  break;
                              }
                        }
                    }
                    else {
                        String subfoldern = inputFile.getName()+"_";
                  	  	saxonSingleFolderTransform(inputFile.toString(), outputDir, xslt, subfoldern);
                    	  break;
                    }

                }
            }
            else
            {
          	  saxonFilesTransform(xmlFolder, outputDir, xslt);
          	  break;
            }
		}
	}
}


