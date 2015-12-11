<%@ Page Language="C#" validateRequest="false" %>
<script runat="server">
public class RqlWebServiceConnector
{
    public string SendRql(string Rql)
    {
    	HttpContext.Current.Response.ContentType = "text/xml; charset=utf-8";
        return SendRqlToWebService(Rql);
    }

    private string SendRqlToWebService(string Rql)
    {
        if (string.IsNullOrEmpty(Rql))
            return "";

        string WebServiceUri = this.GetWebServiceUrl();

        string Response = this.SendRqlToWebService(WebServiceUri, Rql);

        return Response;
    }

    private string SendRqlToWebService(string WebServiceUrl, string Rql)
    {
        System.Net.ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(
            delegate
            {
                return true;
            }
        );

        string Response = "";
        System.Net.WebClient oWC = new System.Net.WebClient();
        oWC.Headers.Add("Content-Type", "text/xml; charset=utf-8");
        oWC.Headers.Add("SOAPAction", "http://tempuri.org/RDCMSXMLServer/action/XmlServer.Execute");

		try
		{
			Response = oWC.UploadString(WebServiceUrl, Rql);
		}
		catch
		{
			Response = "";
		}

        return Response;
    }

    public string GetWebServiceUrl()
    {
        if (HttpContext.Current.Session["WebServiceUrl"] == null)
        {
            HttpContext.Current.Session["WebServiceUrl"] = HttpContext.Current.Request.Url.Scheme + ":" + "//" + "localhost" + "/cms/WebService/RqlWebService.svc";
            Uri WebServiceUri = new Uri(HttpContext.Current.Session["WebServiceUrl"].ToString());

			string Rql = "";
			Rql += "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\">";
			Rql += "<s:Body><q1:Execute xmlns:q1=\"http://tempuri.org/RDCMSXMLServer/message/\"><sParamA></sParamA><sErrorA></sErrorA><sResultInfoA></sResultInfoA></q1:Execute></s:Body>";
			Rql += "</s:Envelope>";
			
            string Response = this.SendRqlToWebService(WebServiceUri.ToString(), Rql);

			if(Response == "")
            {
                if (WebServiceUri.Scheme == "https")
                {
                    HttpContext.Current.Session["WebServiceUrl"] = "http" + "://" + WebServiceUri.Authority + WebServiceUri.PathAndQuery;
                }
                else
                {
                    HttpContext.Current.Session["WebServiceUrl"] = "https" + "://" + WebServiceUri.Authority + WebServiceUri.PathAndQuery;
                }
            }
        }

        return HttpContext.Current.Session["WebServiceUrl"].ToString();
    }
}
</script>
<%
    RqlWebServiceConnector oRqlWebServiceConnector = new RqlWebServiceConnector();

    string Rql = HttpContext.Current.Request["rqlxml"];

    Response.Write(oRqlWebServiceConnector.SendRql(Rql));
%>
