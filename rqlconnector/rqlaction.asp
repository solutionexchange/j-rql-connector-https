<%
	Response.ContentType = "text/xml; charset=utf-8"

    Session.Timeout = 180
	Server.ScriptTimeout = 180

	Dim objIO	'Declare the objects
	Dim xmlData, sError, retXml

	On Error Resume Next
		Set objIO = Server.CreateObject("RDCMSASP.RdPageData")
		objIO.XmlServerClassName = "RDCMSServer.XmlServer"
	If Err.Number <> 0 Then
		Set objIO = Server.CreateObject("OTWSMS.AspLayer.PageData")
	End If

	xmlData = Request.Form("rqlxml")
	xmlData = objIO.ServerExecuteXml (xmlData, sError)
	Set objIO = Nothing

	If xmlData = "" Then
		retXml = "<ERRORTEXT>" & sError & "</ERRORTEXT>"
	Else
		retXml = xmlData
	End If

	Response.Write(retXml)
%>