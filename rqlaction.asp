<%
	'Response.ContentType = "text/xml"

	Dim objIO	'Declare the objects
	Dim xmlData, sError, retXml
	set objIO = Server.CreateObject("RDCMSASP.RdPageData")
	objIO.XmlServerClassName = "RDCMSServer.XmlServer"

	xmlData = Request.Form("rqlxml")
	
	xmlData = objIO.ServerExecuteXml (xmlData, sError) 

	Set objIO = Nothing
	
	retXml = "<RQL>" & xmlData & "<ERROR>" & sError & "</ERROR>" & "</RQL>"
	
	Response.Write(retXml)
%>
