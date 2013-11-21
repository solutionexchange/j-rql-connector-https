<%@ Page Language="C#" validateRequest="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Web" %>
<script runat="server">
    public class RqlWebServiceConnector
    {
        public RqlWebServiceConnector()
        {
			SendRql();
        }
        
        private void SendRql()
        {
            string Rql = HttpContext.Current.Request["rqlxml"];

            HttpContext.Current.Response.Write(SendRqlToWebService(Rql));
        }

        private string SendRqlToWebService(string Rql)
        {
            if (string.IsNullOrEmpty(Rql))
                return "";

            ServicePointManager.ServerCertificateValidationCallback = new System.Net.Security.RemoteCertificateValidationCallback(
                delegate
                {
                    return true;
                }
            );

            string response;
            WebClient WCObj = new WebClient();
            WCObj.Headers.Add("Content-Type", "text/xml; charset=utf-8");
            WCObj.Headers.Add("SOAPAction", "http://tempuri.org/RDCMSXMLServer/action/XmlServer.Execute");
            string WebServiceUrl = HttpContext.Current.Request.Url.Scheme + "://localhost/cms/WebService/RqlWebService.svc";
            response = WCObj.UploadString(WebServiceUrl, Rql);

            return response;
        }

        private string XmlEscape(string unescaped)
        {
            XmlDocument doc = new XmlDocument();
            XmlNode node = doc.CreateElement("root");
            node.InnerText = unescaped;
            return node.InnerXml;
        }
    }

    RqlWebServiceConnector oRqlWebServiceConnector = new RqlWebServiceConnector();
</script>