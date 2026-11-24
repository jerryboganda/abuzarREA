$PBExportHeader$w_selftest.srw
$PBExportComments$Regression aid, not part of the vendor's program: opens every window class named in a list and writes what happened to a log. Runs only when the program is started with /selftest and the database name contains "test".
forward
global type w_selftest from window
end type
end forward

global type w_selftest from window
boolean visible = false
integer width = 1000
integer height = 300
boolean titlebar = true
string title = "Self test"
boolean controlmenu = true
windowtype windowtype = popup!
long backcolor = 67108864
end type
global w_selftest w_selftest

type prototypes
function unsignedlong FindWindowExW (unsignedlong hparent, unsignedlong hafter, string lpclass, long lptitle) library "user32.dll" alias for "FindWindowExW"
function unsignedlong GetWindowThreadProcessId (unsignedlong hwnd, ref unsignedlong lpid) library "user32.dll"
function unsignedlong GetCurrentProcessId () library "kernel32.dll"
function boolean PostMessageW (unsignedlong hwnd, unsignedinteger msg, unsignedlong wparam, long lparam) library "user32.dll" alias for "PostMessageW"
function unsignedlong GetActiveWindow () library "user32.dll"
end prototypes

type variables
string is_names[]
string is_list = "selftest.list"
string is_log = "selftest.log"
long il_index
long il_stuck
long il_dialogs
boolean ib_busy
boolean ib_failed
window iw_current
end variables

forward prototypes
public subroutine wf_log (string as_text)
public function boolean wf_dismiss ()
public function long wf_resume ()
public subroutine wf_error (string as_text)
end prototypes

public subroutine wf_error (string as_text);// called by the application's systemerror event: the script that failed has been stopped; what it opened is
// closed by the next timer events
wf_log("ERROR " + string(il_index) + " " + is_names[il_index] + " | " + as_text)
ib_failed = true
ib_busy = true
end subroutine

public subroutine wf_log (string as_text);// one line, written and closed at once: the log is complete even when the program stops
integer li_file
li_file = fileopen(is_log, linemode!, write!, lockwrite!, append!)
if li_file > 0 then
	filewrite(li_file, string(now(), "hh:mm:ss") + " " + as_text)
	fileclose(li_file)
end if
end subroutine

public function boolean wf_dismiss ();// called while a window under test keeps control (a message box, or a response window): answer the box with
// No / Cancel / OK in turn (never Yes), or close the window that is active.  False = nothing was left to close.
unsignedlong lul_window
unsignedlong lul_pid
unsignedlong lul_me
unsignedlong lul_main
long ll_answer
lul_me = getcurrentprocessid()
lul_window = findwindowexw(0, 0, "#32770", 0)
do while lul_window <> 0
	getwindowthreadprocessid(lul_window, lul_pid)
	if lul_pid = lul_me then
		choose case mod(il_stuck, 3)
			case 1
				ll_answer = 7
			case 2
				ll_answer = 2
			case else
				ll_answer = 1
		end choose
		il_dialogs = il_dialogs + 1
		postmessagew(lul_window, 273, ll_answer, 0)
		return true
	end if
	lul_window = findwindowexw(0, lul_window, "#32770", 0)
loop
if isvalid(iw_current) then
	close(iw_current)
	return true
end if
// a response window opened by the window under test (or the window itself while its open() has not returned)
if isvalid(w_main) then
	lul_main = handle(w_main)
end if
lul_window = getactivewindow()
if lul_window <> 0 and lul_window <> handle(this) and lul_window <> lul_main then
	postmessagew(lul_window, 16, 0, 0)
	return true
end if
return false
end function

public function long wf_resume ();// the entry after the last one the log names; an entry without a result line stopped the program
integer li_file
long ll_last
long ll_pos
string ls_line
string ls_open
li_file = fileopen(is_log, linemode!, read!)
if li_file <= 0 then
	return 0
end if
do while fileread(li_file, ls_line) >= 0
	ll_pos = pos(ls_line, " OPEN ")
	if ll_pos > 0 then
		ls_open = mid(ls_line, ll_pos + 6)
		ll_last = long(left(ls_open, pos(ls_open, " ") - 1))
	elseif pos(ls_line, " OK ") > 0 or pos(ls_line, " ERROR ") > 0 or pos(ls_line, " STOPPED ") > 0 then
		ls_open = ""
	end if
loop
fileclose(li_file)
if ls_open <> "" then
	wf_log("STOPPED " + ls_open + " | the program ended while this window was open")
end if
return ll_last
end function

on w_selftest.create
end on

on w_selftest.destroy
end on

event open;integer li_file
string ls_line
long ll_count
if pos(lower(gs_dbname), "test") = 0 then
	messagebox("Self test", "The self test runs only on a database whose name contains ~"test~".")
	close(this)
	return
end if
li_file = fileopen(is_list, linemode!, read!)
if li_file <= 0 then
	messagebox("Self test", "No list of windows: " + is_list)
	close(this)
	return
end if
do while fileread(li_file, ls_line) >= 0
	ls_line = trim(ls_line)
	if ls_line <> "" then
		ll_count = ll_count + 1
		is_names[ll_count] = ls_line
	end if
loop
fileclose(li_file)
il_index = wf_resume()
wf_log("START at " + string(il_index + 1) + " of " + string(ll_count) + " on " + gs_dbname)
timer(0.3)
end event

event timer;string ls_name
long ll_start
long ll_yield
if ib_busy then
	il_stuck = il_stuck + 1
	if il_stuck > 150 then
		wf_log("STOPPED " + string(il_index) + " " + is_names[il_index] + " | no way out of the window after 45 seconds")
		halt
	end if
	if not wf_dismiss() and ib_failed then
		// after a run-time error nothing of the failed window is left open: go on with the next one
		ib_failed = false
		ib_busy = false
	end if
	return
end if
if il_index >= upperbound(is_names) then
	timer(0)
	wf_log("DONE " + string(il_index))
	halt
end if
il_index = il_index + 1
ls_name = is_names[il_index]
ib_busy = true
il_stuck = 0
il_dialogs = 0
ll_start = cpu()
wf_log("OPEN " + string(il_index) + " " + ls_name)
try
	setnull(iw_current)
	open(iw_current, ls_name)
	// let the events the window posts to itself run (ue_postopen connects to the database, retrieves ...): closing
	// before them is not what a user can do
	for ll_yield = 1 to 20
		yield()
	next
	if ib_failed then
		return                                  // reported by the systemerror event; the next timer events clean up
	end if
	if isvalid(iw_current) then
		close(iw_current)
	end if
	wf_log("OK " + string(il_index) + " " + ls_name + " | " + string(cpu() - ll_start) + " ms, dialogs answered " + string(il_dialogs))
catch (runtimeerror lre_error)
	wf_log("ERROR " + string(il_index) + " " + ls_name + " | " + lre_error.getmessage() + " | " + lre_error.objectname + "." + lre_error.routinename + " line " + string(lre_error.line))
	if isvalid(iw_current) then
		close(iw_current)
	end if
end try
ib_busy = false
end event

