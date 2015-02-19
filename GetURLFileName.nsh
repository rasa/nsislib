!ifndef _GetURLFileName_nsh
!define _GetURLFileName_nsh

!macro GetURLFileNameCall _FILESTRING _RESULT
	!verbose push
	!verbose ${_FILEFUNC_VERBOSE}
	Push `${_FILESTRING}`
	Call GetURLFileName
	Pop ${_RESULT}
	!verbose pop
!macroend

!macro GetURLFileName
	!ifndef ${_FILEFUNC_UN}GetURLFileName
		!verbose push
		!verbose ${_FILEFUNC_VERBOSE}
		!define ${_FILEFUNC_UN}GetURLFileName `!insertmacro ${_FILEFUNC_UN}GetURLFileNameCall`

		Function ${_FILEFUNC_UN}GetURLFileName
			Exch $0
			Push $1
			Push $2

			StrCpy $2 $0 1 -1
			StrCmp $2 '/' 0 +3
			StrCpy $0 $0 -1
			goto -3

			StrCpy $1 0
			IntOp $1 $1 - 1
			StrCpy $2 $0 1 $1
			StrCmp $2 '' end
			StrCmp $2 '/' 0 -3
			IntOp $1 $1 + 1
			StrCpy $0 $0 '' $1

			end:
			Pop $2
			Pop $1
			Exch $0
		FunctionEnd

		!verbose pop
	!endif
!macroend

!endif # _GetURLFileName_nsh
