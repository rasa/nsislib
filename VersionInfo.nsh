!ifndef _VersionInfo_nsh
!define _VersionInfo_nsh

!ifndef PRODUCT_VERSION4
!define PRODUCT_VERSION4 "${PRODUCT_VERSION}.0.0"
!endif

!macro VersionInfo
	# from C:/Program Files/NSIS/Examples/VersionInfo.nsi:
	VIProductVersion "${PRODUCT_VERSION4}"
	VIAddVersionKey "Comments"			"Built on ${__DATE__} at ${__TIME__}"
	VIAddVersionKey "CompanyName"		"${PRODUCT_PUBLISHER} (${PRODUCT_WEB_SITE})"
	VIAddVersionKey "FileDescription"	"${PRODUCT_DESC}"
	VIAddVersionKey "FileVersion"		"${PRODUCT_VERSION4}"
	VIAddVersionKey "InternalName"		"${PRODUCT_DESC}"
	VIAddVersionKey "LegalCopyright"	"${PRODUCT_COPYRIGHT}"
	VIAddVersionKey "OriginalFilename"	"${PRODUCT_EXE}"
	VIAddVersionKey "PrivateBuild"		""
	VIAddVersionKey "ProductName"		"${PRODUCT_DESC}"
	VIAddVersionKey "ProductVersion"	"${PRODUCT_VERSION4}"
	VIAddVersionKey "SpecialBuild"		""
	VIAddVersionKey "LegalTrademarks"	"${PRODUCT_TRADEMARKS}"
!macroend

!endif # _VersionInfo_nsh
