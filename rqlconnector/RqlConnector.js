function RqlConnector(LoginGuid, SessionKey) {
    this.LoginGuid = LoginGuid;
    this.SessionKey = SessionKey;
    this.DCOM = 'DCOM';
    this.DCOMProxyUrl = 'rqlconnector/rqlaction.asp';
    this.WebService11 = 'WebService11';
    this.WebService11ProxyUrl = 'rqlconnector/rqlactionwebservice.aspx';
    this.WebService11Url = '/CMS/WebService/RqlWebService.svc';
    this.RqlConnectionType = '';
}

RqlConnector.prototype.SetConnectionType = function (ConnectionType) {
    this.RqlConnectionType = ConnectionType;
}

RqlConnector.prototype.GetConnectionType = function (CallbackFunc) {
    var ThisClass = this;

    if (this.RqlConnectionType == '') {
        this.TestConnection(this.WebService11Url, function(data) {
            if (data) {
                ThisClass.SetConnectionType(ThisClass.WebService11);
            } else {
                ThisClass.SetConnectionType(ThisClass.DCOM);
            }

            if (CallbackFunc) {
                CallbackFunc(ThisClass.RqlConnectionType);
            }
        });
    } else {
        if (CallbackFunc) {
            CallbackFunc(ThisClass.RqlConnectionType);
        }
    }
}

RqlConnector.prototype.SendRql = function (InnerRQL, IsText, CallbackFunc) {
    var ThisClass = this;

    this.GetConnectionType(function(data) {
        switch (data) {
            case ThisClass.DCOM:
                ThisClass.SendRqlCOM(InnerRQL, IsText, CallbackFunc);
                break;
            case ThisClass.WebService11:
                ThisClass.SendRqlWebService(InnerRQL, IsText, CallbackFunc);
                break;
        }
    });
}

RqlConnector.prototype.SendRqlWebService = function (InnerRQL, IsText, CallbackFunc) {
    var SOAPMessage = '';
    SOAPMessage += '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">';
    SOAPMessage += '<s:Body><q1:Execute xmlns:q1="http://tempuri.org/RDCMSXMLServer/message/"><sParamA>';
    SOAPMessage += '<![CDATA[' + this.PadRQLXML(InnerRQL, IsText) + ']]>';
    SOAPMessage += '</sParamA><sErrorA></sErrorA><sResultInfoA></sResultInfoA></q1:Execute></s:Body>';
    SOAPMessage += '</s:Envelope>';

    $.post(this.WebService11ProxyUrl, {rqlxml: SOAPMessage, webserviceurl: this.WebService11Url}, function (data) {
        data = $.trim(data);

        var RetRql = $($.parseXML(data)).find('Result').text();
        RetRql = $.trim(RetRql);

        if (IsText) {
            data = RetRql;
        }
        else {
            data = $.parseXML(RetRql);
        }

        CallbackFunc(data);
    }, 'text');
}

RqlConnector.prototype.SendRqlCOM = function (InnerRQL, IsText, CallbackFunc) {
    var Rql = this.PadRQLXML(InnerRQL, IsText);
    $.post(this.DCOMProxyUrl, {rqlxml: Rql}, function (data) {
        data = $.trim(data);

        if (IsText) {
            // do nothing
        }
        else {
            data = $.parseXML(data);
        }

        CallbackFunc(data);
    }, 'text');
}

RqlConnector.prototype.PadRQLXML = function (InnerRQL, IsText) {
    var Rql = '<IODATA loginguid="' + this.LoginGuid + '" sessionkey="' + this.SessionKey + '">';

    if (IsText) {
        Rql = '<IODATA loginguid="' + this.LoginGuid + '" sessionkey="' + this.SessionKey + '" format="1">';
    }

    Rql += InnerRQL;
    Rql += '</IODATA>';

    return Rql;
}

RqlConnector.prototype.TestConnection = function (Url, CallbackFunc) {
    $.ajax({
        async: true,
        url: Url,
        success: function () {
            if (CallbackFunc) {
                CallbackFunc(true);
            }
        },
        error: function () {
            if (CallbackFunc) {
                CallbackFunc(false);
            }
        }
    });
}