$PBExportHeader$basichttpbinding_icorporatecbs.sru
$PBExportComments$Zong corporate SMS service (ICorporateCBS), operation QuickSMS. Replaces the .NET web service proxy of PowerBuilder 12.5 (Service1.dll) with a plain SOAP 1.1 request sent by HTTPClient. Action, namespaces and member names are the ones of the vendor's proxy assembly.
forward
global type basichttpbinding_icorporatecbs from nonvisualobject
end type
end forward

global type basichttpbinding_icorporatecbs from nonvisualobject
end type
global basichttpbinding_icorporatecbs basichttpbinding_icorporatecbs

type variables
string is_endpoint = "http://cbs.zong.com.pk/ReachCWSv2/CorporateSMS.svc"
long il_timeout_seconds = 60
end variables

forward prototypes
public subroutine of_setendpoint (string as_endpoint)
public function string of_xml (string as_text)
public function string of_unxml (string as_text)
public function string quicksms (quicksmsresquest obj_quicksms)
end prototypes

public subroutine of_setendpoint (string as_endpoint);if not isnull(as_endpoint) and trim(as_endpoint) <> "" then
	is_endpoint = trim(as_endpoint)
end if
end subroutine

public function string of_xml (string as_text);// text as XML element content
long ll_pos
if isnull(as_text) then
	return ""
end if
ll_pos = pos(as_text, "&")
do while ll_pos > 0
	as_text = replace(as_text, ll_pos, 1, "&amp;")
	ll_pos = pos(as_text, "&", ll_pos + 5)
loop
ll_pos = pos(as_text, "<")
do while ll_pos > 0
	as_text = replace(as_text, ll_pos, 1, "&lt;")
	ll_pos = pos(as_text, "<", ll_pos + 4)
loop
ll_pos = pos(as_text, ">")
do while ll_pos > 0
	as_text = replace(as_text, ll_pos, 1, "&gt;")
	ll_pos = pos(as_text, ">", ll_pos + 4)
loop
return as_text
end function

public function string of_unxml (string as_text);// XML element content as text
long ll_pos
string ls_from[] = {"&lt;", "&gt;", "&quot;", "&apos;", "&amp;"}
string ls_to[] = {"<", ">", '"', "'", "&"}
integer li_i
for li_i = 1 to 5
	ll_pos = pos(as_text, ls_from[li_i])
	do while ll_pos > 0
		as_text = replace(as_text, ll_pos, len(ls_from[li_i]), ls_to[li_i])
		ll_pos = pos(as_text, ls_from[li_i], ll_pos + 1)
	loop
next
return as_text
end function

public function string quicksms (quicksmsresquest obj_quicksms);// Sends one SMS. Returns the text the service answers with; any failure to reach the service or to read its
// answer is thrown as soapexception, as the 12.5 proxy did (the caller counts the message as not sent).
httpclient lnv_http
soapexception lex_error
string ls_request
string ls_response
string ls_result
integer li_rc
long ll_status
long ll_start
long ll_end

if isnull(obj_quicksms) or not isvalid(obj_quicksms) then
	lex_error = create soapexception
	lex_error.setmessage("QuickSMS: no request")
	throw lex_error
end if

ls_request = '<?xml version="1.0" encoding="utf-8"?>' &
	+ '<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/"><s:Body>' &
	+ '<QuickSMS xmlns="http://tempuri.org/">' &
	+ '<obj_QuickSMS xmlns:a="http://schemas.datacontract.org/2004/07/CBSCustomerAPI">' &
	+ '<a:loginId>' + of_xml(obj_quicksms.loginid) + '</a:loginId>' &
	+ '<a:loginPassword>' + of_xml(obj_quicksms.loginpassword) + '</a:loginPassword>' &
	+ '<a:Destination>' + of_xml(obj_quicksms.destination) + '</a:Destination>' &
	+ '<a:Mask>' + of_xml(obj_quicksms.mask) + '</a:Mask>' &
	+ '<a:Message>' + of_xml(obj_quicksms.ws_message) + '</a:Message>' &
	+ '<a:UniCode>' + of_xml(obj_quicksms.unicode) + '</a:UniCode>' &
	+ '<a:ShortCodePrefered>' + of_xml(obj_quicksms.shortcodeprefered) + '</a:ShortCodePrefered>' &
	+ '</obj_QuickSMS></QuickSMS></s:Body></s:Envelope>'

lnv_http = create httpclient
lnv_http.timeout = il_timeout_seconds
lnv_http.setrequestheader("Content-Type", "text/xml; charset=utf-8")
lnv_http.setrequestheader("SOAPAction", '"http://tempuri.org/ICorporateCBS/QuickSMS"')
li_rc = lnv_http.sendrequest("POST", is_endpoint, ls_request, encodingutf8!)
if li_rc = 1 then
	ll_status = lnv_http.getresponsestatuscode()
	lnv_http.getresponsebody(ls_response, encodingutf8!)
end if
destroy lnv_http

if li_rc <> 1 then
	lex_error = create soapexception
	lex_error.setmessage("QuickSMS: the SMS service could not be reached (HTTPClient result " + string(li_rc) + ")")
	throw lex_error
end if
if ll_status <> 200 then
	lex_error = create soapexception
	lex_error.setmessage("QuickSMS: the SMS service answered with HTTP status " + string(ll_status))
	throw lex_error
end if

ll_start = pos(ls_response, "QuickSMSResult")
if ll_start > 0 then
	ll_start = pos(ls_response, ">", ll_start)
end if
if ll_start > 0 then
	ll_end = pos(ls_response, "</", ll_start)
end if
if ll_start = 0 or ll_end = 0 then
	// an empty result element (<QuickSMSResult/>) is an answer too
	if pos(ls_response, "QuickSMSResponse") > 0 then
		return ""
	end if
	lex_error = create soapexception
	lex_error.setmessage("QuickSMS: the answer of the SMS service was not understood")
	throw lex_error
end if
ls_result = of_unxml(mid(ls_response, ll_start + 1, ll_end - ll_start - 1))
return ls_result
end function

on basichttpbinding_icorporatecbs.create
call super::create
triggerevent("constructor")
end on

on basichttpbinding_icorporatecbs.destroy
triggerevent("destructor")
call super::destroy
end on

