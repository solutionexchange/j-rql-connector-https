j-rql-connector-https
=====================

An all version compatible RQL connector written in JavaScript/JQuery.  This flavor works in both HTTP and HTTPS.

Usage
=====
```
<script type="text/javascript" src="rqlconnector/Rqlconnector.js"></script>
<script type='text/javascript'>
	var LoginGuid = '<%= session("loginguid") %>';
	var SessionKey = '<%= session("sessionkey") %>';
	var RqlConnectorObj = new RqlConnector(LoginGuid, SessionKey);
  
	function LoadPageSimpleInfo(PageGuid)
	{
		//load simple page info
		var strRQLXML = '<PAGE action="load" guid="' + PageGuid + '"/>';
			
		RqlConnectorObj.SendRql(strRQLXML, false, function(data){
			//alert($(data).find('PAGE').attr('headline'));
		});
	}
</script>
```
