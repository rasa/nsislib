# Copyright (c) 2005-2015 Ross Smith II (http://smithii.com). MIT Licensed.

!ifndef PRODUCT_NAME
!error "PRODUCT_NAME is not defined"
!endif
!ifndef PRODUCT_VERSION
!error "PRODUCT_VERSION is not defined"
!endif
!ifndef PRODUCT_EXE
!define PRODUCT_EXE "${PRODUCT_NAME}.exe"
!endif
!ifndef PRODUCT_UNEXE
!define PRODUCT_UNEXE "Uninstall-${PRODUCT_NAME}.exe"
!endif
!ifndef PRODUCT_FILE
!define PRODUCT_FILE "Release\${PRODUCT_EXE}"
!endif
!ifndef PRODUCT_DIR
!define PRODUCT_DIR "${PRODUCT_NAME}"
!endif
!ifndef PRODUCT_INSTALL_DIR
	!ifdef INSTALL_IN_PROGRAMFILES64
		!define PRODUCT_INSTALL_DIR "$PROGRAMFILES64\${PRODUCT_DIR}"
	!else
		!define PRODUCT_INSTALL_DIR "$PROGRAMFILES\${PRODUCT_DIR}"
	!endif
!endif
!ifndef PRODUCT_OUTFILE
!define PRODUCT_OUTFILE "${PRODUCT_NAME}-${PRODUCT_VERSION}-win32.exe"
!endif
!ifndef PRODUCT_DESC
	!ifdef INSTALL_IN_PROGRAMFILES64
		!define PRODUCT_DESC "${PRODUCT_NAME} ${PRODUCT_VERSION} (64-Bit Version)"
	!else
		!define PRODUCT_DESC "${PRODUCT_NAME} ${PRODUCT_VERSION}"
	!endif
!endif
!ifndef PRODUCT_PUBLISHER
!define PRODUCT_PUBLISHER "Ross Smith II"
!endif
!ifndef PRODUCT_COPYRIGHT
!define PRODUCT_COPYRIGHT "Copyright © 2005-2015 ${PRODUCT_PUBLISHER} (${PRODUCT_WEB_SITE})"
!endif
!ifndef PRODUCT_WEB_SITE
!define PRODUCT_WEB_SITE "http://smithii.com"
!endif
!ifndef PRODUCT_URL
!define PRODUCT_URL "http://www.google.com/custom?client=pub-4570504899851879&domains=smithii.com&sitesearch=smithii.com&q=${PRODUCT_NAME}"
!endif
!ifndef PRODUCT_DIR_REGKEY
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE}"
!endif
!ifndef PRODUCT_UNINST_KEY
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!endif
!ifndef PRODUCT_UNINST_ROOT_KEY
!define PRODUCT_UNINST_ROOT_KEY "HKCU"
!endif
!ifndef PRODUCT_STARTMENU_REGVAL
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"
!endif
