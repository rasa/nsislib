!define MUI_COMPONENTSPAGE_SMALLDESC

; MUI 1.67 compatible ------

!include "MUI.nsh"

; MUI Settings
!define MUI_ABORTWARNING
!ifndef MUI_ICON
!define MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\modern-install.ico"
!endif
!ifndef MUI_UNICON 
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!endif

; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "license.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Directory page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var STARTMENU_FOLDER

!define MUI_STARTMENUPAGE_NODISABLE

!ifndef MUI_STARTMENUPAGE_DEFAULTFOLDER
	!define MUI_STARTMENUPAGE_DEFAULTFOLDER "${PRODUCT_DIR}"
!endif

!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"

!insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER

; Instfiles page
!insertmacro MUI_PAGE_INSTFILES

; Finish page
!ifdef ${PRODUCT_EXE}
	!ifndef MUI_FINISHPAGE_RUN
		!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_EXE}"
	!endif
!endif
!insertmacro MUI_PAGE_FINISH

; PRODUCT_UNEXE pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"
