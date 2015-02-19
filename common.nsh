# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!include "config.nsh"

!include "FileFunc.nsh"

!include "AddToPath.nsh"

!include "ConnectInternet.nsh"

!include "Download.nsh"

!include "VersionInfo.nsh"

!insertmacro VersionInfo

# http://nsis.sourceforge.net/Can_I_prevent_the_user_from_running_multiple_instances_of_the_installer

!macro AbortIfRunning
	System::Call 'kernel32::CreateMutexA(i 0, i 0, t "${PRODUCT_NAME}_${__DATE__}_${__TIME__}") i .r1 ?e'
	Pop $R0
	StrCmp $R0 0 +3
	  MessageBox MB_OK|MB_ICONEXCLAMATION "The installer is already running."
	  Abort
!macroend

!insertmacro GetOptions

!macro SetCurInstType
	${GetOptions} "$CMDLINE" "/INSTYPE" $0
	IfErrors +2
		SetCurInstType $0
!macroend

!macro AddInstDirToPath
	Push $INSTDIR
	Call AddToPath
!macroend

!macro RemoveInstDirFromPath
	Push $INSTDIR
	Call un.RemoveFromPath
!macroend

!include "_MUI.nsh"

Name "${PRODUCT_DESC}"
OutFile "${PRODUCT_OUTFILE}"
InstallDir "${PRODUCT_INSTALL_DIR}"
InstallDirRegKey HKCU "${PRODUCT_DIR_REGKEY}" ""
ShowInstDetails show
ShowUnInstDetails show
XPStyle on

Function .onInit
	!insertmacro AbortIfRunning
	!insertmacro SetCurInstType
FunctionEnd

Section -Init
	SetOutPath "$INSTDIR"
	SetOverwrite ifnewer
!ifdef ${PRODUCT_FILE}
	File "${PRODUCT_FILE}"
!endif

	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
!ifndef NO_STARTMENU_ICONS
	CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
	!ifdef ${PRODUCT_EXE}
		CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE}"
	!endif
!endif
!ifndef NO_DESKTOP_ICONS
	!ifdef ${PRODUCT_EXE}
		CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE}"
	!endif
!endif
	!insertmacro MUI_STARTMENU_WRITE_END
!ifdef ADD_INSTDIR_TO_PATH
	!insertmacro AddInstDirToPath
!endif
SectionEnd

Section -AdditionalIcons
	!insertmacro MUI_STARTMENU_WRITE_BEGIN Application
!ifndef NO_STARTMENU_ICONS
	WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_URL}"
	CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\ Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
	CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\ Uninstall.lnk" "$INSTDIR\${PRODUCT_UNEXE}"
!endif
	!insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
	WriteUninstaller "$INSTDIR\${PRODUCT_UNEXE}"
	!ifdef ${PRODUCT_EXE}
		WriteRegStr HKCU "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\${PRODUCT_EXE}"
	!endif
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\${PRODUCT_UNEXE}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\${PRODUCT_UNEXE}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_URL}"
	WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

#; Section descriptions
#!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
#  !insertmacro MUI_DESCRIPTION_TEXT ${SEC01} ""
#!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function un.onInit
	!insertmacro AbortIfRunning
	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
	Abort
FunctionEnd

Function un.onUninstSuccess
	HideWindow
	MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Section Uninstall
!ifdef ADD_INSTDIR_TO_PATH
	!insertmacro RemoveInstDirFromPath
!endif
	!insertmacro MUI_STARTMENU_GETFOLDER Application $STARTMENU_FOLDER

!ifndef NO_STARTMENU_ICONS
	Delete "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk"
	Delete "$INSTDIR\${PRODUCT_NAME}.url"
	Delete "$SMPROGRAMS\$STARTMENU_FOLDER\Website.lnk"
	Delete "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk"
	Delete "$SMPROGRAMS\$STARTMENU_FOLDER\ Website.lnk"
	Delete "$SMPROGRAMS\$STARTMENU_FOLDER\ Uninstall.lnk"
	RMDir /r "$SMPROGRAMS\$STARTMENU_FOLDER"
!endif

!ifndef NO_DESKTOP_ICONS
	Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
!endif

	!ifdef ${PRODUCT_EXE}
		Delete "$INSTDIR\${PRODUCT_EXE}"
	!endif
	Delete "$INSTDIR\${PRODUCT_UNEXE}"

	MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2  "Are you sure you want to delete all the files in the directory $INSTDIR?" IDNO +2
		RMDir /r "$INSTDIR"

	DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
	DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
	SetAutoClose true
SectionEnd
