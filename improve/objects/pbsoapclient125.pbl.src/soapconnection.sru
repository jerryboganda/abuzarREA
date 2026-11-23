$PBExportHeader$soapconnection.sru
$PBExportComments$Stands in for the SOAP connection of the PowerBuilder 12.5 extension (pbsoapclient125): keeps the options and gives the proxy its address. The call itself is made by the proxy with HTTPClient.
forward
global type soapconnection from nonvisualobject
end type
end forward

global type soapconnection from nonvisualobject
end type
global soapconnection soapconnection

type variables
string is_options
end variables

forward prototypes
public function long setoptions (string as_options)
public function long createinstance (ref powerobject apo_proxy, string as_proxyname, string as_endpoint)
end prototypes

public function long setoptions (string as_options);// The 12.5 extension took: SoapLog, UserID, Password, Timeout, ConnectionCache.
// Nothing is written to a log file here: the old option wrote the login and password of the SMS account to C:\mySoapLog.log.
is_options = as_options
return 0
end function

public function long createinstance (ref powerobject apo_proxy, string as_proxyname, string as_endpoint);// 0 = the proxy is ready (the return value of the 12.5 extension), 100 = no proxy
if isnull(apo_proxy) or not isvalid(apo_proxy) then
	return 100
end if
apo_proxy.dynamic of_setendpoint(as_endpoint)
return 0
end function

on soapconnection.create
call super::create
triggerevent("constructor")
end on

on soapconnection.destroy
triggerevent("destructor")
call super::destroy
end on

