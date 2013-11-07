<%
	Response.ContentType = "text/xml"
	
	Dim WebService11Url
	WebService11Url = "http://" & Request.ServerVariables("SERVER_NAME") & Request.Form("webserviceurl")
	
	Dim xmlData
	xmlData = Request.Form("rqlxml")

	Set oXmlHTTP = CreateObject("Microsoft.XMLHTTP")
	oXmlHTTP.Open "POST", WebService11Url, False 
	oXmlHTTP.setRequestHeader "Content-Type", "text/xml; charset=utf-8" 
	oXmlHTTP.setRequestHeader "SOAPAction", "http://tempuri.org/RDCMSXMLServer/action/XmlServer.Execute"
	
	Dim SOAPMessage
	SOAPMessage = xmlData
	
	oXmlHTTP.send SOAPMessage 
	Response.Write(oXmlHTTP.responseXML.xml)
%>