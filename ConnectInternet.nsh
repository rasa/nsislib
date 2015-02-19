# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!ifndef _ConnectInternet_nsh
!define _ConnectInternet_nsh

Function ConnectInternet
	Push $R0

	ClearErrors
	Dialer::AttemptConnect
	IfErrors noie3

	Pop $R0
	StrCmp $R0 "online" connected
	  MessageBox MB_OK|MB_ICONSTOP "Cannot connect to the Internet."
	  Quit

	noie3:

	; IE3 not installed
	MessageBox MB_OK|MB_ICONINFORMATION "Please connect to the Internet now."

	connected:

	Pop $R0
FunctionEnd

!endif # _ConnectInternet_nsh
