$PBExportHeader$soapexception.sru
$PBExportComments$Error of a web service call. Stands in for the class of the PowerBuilder 12.5 SOAP client extension (pbsoapclient125), which the 2022 runtime no longer has.
forward
global type soapexception from runtimeerror
end type
end forward

global type soapexception from runtimeerror
end type
global soapexception soapexception

on soapexception.create
call super::create
triggerevent("constructor")
end on

on soapexception.destroy
triggerevent("destructor")
call super::destroy
end on

