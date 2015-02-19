# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!ifndef _Download_nsh
!define _Download_nsh

!include "GetURLFileName.nsh"
!insertmacro GetURLFileName

ReserveFile "${NSISDIR}\Plugins\nsUnzip.dll"
!ifdef CHECK_MD5
	ReserveFile "${NSISDIR}\Plugins\md5dll.dll"
!endif

!define DOWNLOAD_RETRIES 0
!define RETRY_WAIT 1000

var /GLOBAL download_retries

!macro Download1 url dir referer
DetailPrint "url=${url}"
DetailPrint "dir=${dir}"
DetailPrint "Referer=${referer}"
	${GetURLFileName} '${url}' $1

	DetailPrint "Looking for $EXEDIR\$1"

	FindFirst $0 $3 "$EXEDIR\$1"
	DetailPrint "Found '$3'"
	FindClose $0

	StrCpy $2 "$EXEDIR\$1"
	StrCmp "$3" "" download md5

	download:

	DetailPrint "'$3' not found, will download"

	Call ConnectInternet

	StrCpy $2 "$TEMP\$1"
	DetailPrint "Downloading ${url} to $2"

	restart:

	IntOp $download_retries ${DOWNLOAD_RETRIES} + 0

	retry:
		DetailPrint "Deleting '$2'"
		Delete $2
		StrCmp "${referer}" "" noreferer
referer:
		DetailPrint "54 Downloading ${url} to $2 (Referer ${referer})"
    	inetc::get /HEADER "Referer: ${referer}" ${url} $2 /end
		Goto after_download
noreferer:
		DetailPrint "50 Downloading ${url} to $2"
    	inetc::get ${url} $2 /end
after_download:
		DetailPrint "Finishing downloading ${url} $2: result: $0"
		Pop $0
		StrCmp $0 "OK" success

		SetDetailsView show
		DetailPrint "Error: $0, retrying $download_retries more time(s)"
		IntOp $download_retries $download_retries - 1
		IntCmp $download_retries 0 download_error download_error
		Sleep ${RETRY_WAIT}
	Goto retry

	download_error:
		SetDetailsView show
		DetailPrint "Failed to download ${url}: $0"

		MessageBox MB_RETRYCANCEL "Failed to download ${url}: $0?" /SD IDCANCEL IDRETRY restart
		Abort
	success:

	md5:

!ifdef CHECK_MD5
	DetailPrint "Checking MD5 for $2"

	md5dll::GetMD5File "$2"
	Pop $0
	StrCmp "$0" "${md5}" md5ok
		SetDetailsView show
		DetailPrint "Failed MD5 check for $2: expected ${md5}, found $0"
		Abort
	md5ok:
!endif # CHECK_MD5

!macroend # Download1


!macro Download url dir referer
	!insertmacro Download1 "${url}" "${dir}" "${referer}"

!ifdef COPYDIR
	StrCmp "$3" "" copy dont_copy
	copy:
	DetailPrint "Copying $2 to ${COPYDIR}"
	CopyFiles /SILENT "$2" "${COPYDIR}"
	dont_copy:
!else
	DetailPrint "Copying $2 to $INSTDIR\${dir}"
	CopyFiles /SILENT "$2" "$INSTDIR\${dir}"
!endif
	DetailPrint "Deleting $TEMP\$1"
  	Delete "$TEMP\$1"
!macroend

!macro DownloadAndCopy url dir referer
	!insertmacro Download1 "${url}" "${dir}" "${referer}"

	DetailPrint "Copying $2 to ${UNZIP_DIR}\${dir}"
	CopyFiles /SILENT "$2" "${UNZIP_DIR}\${dir}"

!ifdef COPYDIR
	StrCmp "$3" "" copy dont_copy
	copy:
	DetailPrint "Copying $2 to ${COPYDIR}"
	CopyFiles /SILENT "$2" "${COPYDIR}"
	dont_copy:
!else
	DetailPrint "Copying $2 to $INSTDIR\${dir}"
	CopyFiles /SILENT "$2" "$INSTDIR\${dir}"
!endif
	DetailPrint "Deleting $TEMP\$1"
  	Delete "$TEMP\$1"
!macroend


!macro DownloadZip url dir referer
	!insertmacro Download1 "${url}" "${dir}" "${referer}"

	DetailPrint "Unzipping $2 to ${UNZIP_DIR}\${dir}"

!ifdef NOEXTRACTPATH
	DetailPrint "nsUnzip::Extract /j $2 /d=${UNZIP_DIR}\${dir} /END"
	nsUnzip::Extract /j $2 "/d=${UNZIP_DIR}\${dir}" /END
#	nsisunz::UnzipToLog /noextractpath $2 "${UNZIP_DIR}\${dir}"
!else
	DetailPrint "nsUnzip::Extract $2 /d=${UNZIP_DIR}\${dir} /END"
	nsUnzip::Extract $2 "/d=${UNZIP_DIR}\${dir}" /END
#	nsisunz::UnzipToLog $2 "${UNZIP_DIR}\${dir}"
!endif # NOEXTRACTPATH

	Pop $0
	StrCmp $0 "0" ok
		DetailPrint "Failed to unzip $2: $0"
		Abort
	ok:

!ifdef COPYDIR
	StrCmp "$3" "" copy dont_copy
	copy:
	DetailPrint "Copying $2 to ${COPYDIR}"
	CopyFiles /SILENT "$2" "${COPYDIR}"
	dont_copy:
!endif
	DetailPrint "Deleting $TEMP\$1"
  	Delete "$TEMP\$1"
!macroend

!define SECTION_NO 0
!define _SECTION_NO 0
!tempfile DESCRIPTION_FILE
!appendfile "${DESCRIPTION_FILE}" "!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN$\n"

!macro appendfile sectionno description
	!appendfile "${DESCRIPTION_FILE}" "!insertmacro MUI_DESCRIPTION_TEXT ${${sectionno}} '${description}'$\n"
!macroend

!macro DownloadGUI sectionin title url exe dir referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro DownloadZip "${url}" "${dir}" "${referer}"

		StrCmp "${exe}" "" noexe
			CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${title}.lnk" "$INSTDIR\${exe}" "" "$INSTDIR\${exe}" 0
		noexe:
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"

#	Section "un.${title}"
#		Delete "$SMPROGRAMS\${PRODUCT_DIR}\${title}.lnk"
#	SectionEnd
!macroend

!macro DownloadGUI2 sectionin title url exe dir parameters referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro DownloadZip "${url}" "${dir}" "${referer}"

		StrCmp "${exe}" "" noexe
			CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${title}.lnk" "$INSTDIR\${exe}" "${parameters}" "$INSTDIR\${exe}" 0
		noexe:
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"

#	Section "un.${title}"
#		Delete "$SMPROGRAMS\${PRODUCT_DIR}\${title}.lnk"
#	SectionEnd
!macroend

!macro DownloadSCR sectionin title url exe dir referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro DownloadZip "${url}" "${dir}" "${referer}"

		CopyFiles /SILENT "$INSTDIR\${exe}"	"$SYSDIR\${exe}"
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"

#	Section "un.${title}"
#		Delete "$SYSDIR\${exe}"
#	SectionEnd
!macroend

!macro DownloadCLI sectionin title url dir referer

	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro DownloadZip "${url}" "${dir}" "${referer}"
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"
!macroend

!macro DownloadEXE sectionin title url dir referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro Download "${url}" "${dir}" "${referer}"
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"
!macroend

!macro DownloadAny sectionin title url dir referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro Download "${url}" "${dir}" "${referer}"
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"
!macroend

!macro DownloadCpy sectionin title url dir referer
	!undef _SECTION_NO
	!define _SECTION_NO ${SECTION_NO}
	!undef SECTION_NO
	!define /math SECTION_NO ${_SECTION_NO} + 1

	Section "${title}" Section${SECTION_NO}
LogSet On
		SectionIn ${sectionin}

		!insertmacro DownloadAndCopy "${url}" "${dir}" "${referer}"
	SectionEnd

	!insertmacro appendfile "Section${SECTION_NO}" "${url}"
!macroend

!endif # _Download_nsh
