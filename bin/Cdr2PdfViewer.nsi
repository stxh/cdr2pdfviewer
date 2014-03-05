;=========================================
; TinyServer (Cdr2PdfViewer)
; Install Script
;
; For NSIS 2.x
; By StXh <stxh007@gmail.com>
; 2014-03-04 18:07:10
;=========================================

SetCompressor /SOLID lzma
RequestExecutionLevel Admin

!include "MUI.nsh"
!include "Library.nsh"

!include "FileAssociation.nsh"

;Setup Name

;!System 'd:\tools\UPX -9 --force *.exe'

!define SOFT_VERSION "1.0.0.0"

Name "Cdr2PdfViewer v${SOFT_VERSION} ${__DATE__}"

!define SOFT_NAME 	"Cdr2PdfViewer"
!define SOFT_DESC 	"Cdr2PdfViewer (Convert CDR to PDF and start Viewer)"
!define COMPANY   	"StXh"
!define PROJECT     "C2PV"

;Branding text
BrandingText "${SOFT_DESC}"

!define INSTALL_MENU_DIR "Cdr2PdfViewer"

;License Introduction + Filename
;LicenseText "Please read the license before continuing:"
;LicenseData "license.txt"

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM Software\${COMPANY}\${PROJECT} Path
InstallDir "$PROGRAMFILES\Cdr2PdfViewer"


; -------------------------------
; Start


  !define MUI_BRANDINGTEXT "$SOFT_DESC"
  CRCCheck On


;--------------------------------
;General

  OutFile "${SOFT_NAME}-Setup-${SOFT_VERSION}.exe"
  ShowInstDetails "nevershow"
  ShowUninstDetails "nevershow"

!define MUI_ICON "images\icon.ico"
!define MUI_UNICON "images\nsis1-uninstall.ico"
;!define MUI_DIRECTORYPAGE_BITMAP "images\Banner.bmp"
;!define MUI_WELCOMEFINISHPAGE_BITMAP "images\setupbanner.bmp"

;--------------------------------
;Folder selection page


;--------------------------------
;Modern UI Configuration

  !define MUI_WELCOMEPAGE
;  !define MUI_LICENSEPAGE
  !define MUI_DIRECTORYPAGE
  !define MUI_COMPONENTSPAGE_SMALLDESC
  !define MUI_ABORTWARNING
  !define MUI_UNINSTALLER
  !define MUI_UNCONFIRMPAGE
  !define MUI_FINISHPAGE
  !define MUI_FINISHPAGE_LINK "Click here to goto Cdr2PdfViewer on github"
  !define MUI_FINISHPAGE_LINK_LOCATION "http://github.com/stxh/cdr2pdfviewer"
  ;!define MUI_FINISHPAGE_RUN_TEXT "Run $(Name)"

  !insertmacro MUI_PAGE_WELCOME
;  !insertmacro MUI_PAGE_LICENSE "License.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Language

  !insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Modern UI System
;  !insertmacro MUI_SYSTEM


;--------------------------------
;Data
;  LicenseData "license.txt"

;--------------------------------
;Installer Sections
Section "Cdr2PdfViewer" mainInstall

	WriteRegStr HKLM Software\${COMPANY}\${PROJECT} Path $INSTDIR

;Add files

	SetOverwrite on

	SetOutPath "$INSTDIR"
	File cdr2pdfviewer.exe
	File cdr2pdfviewer.cmd

	;point your UniConvertor directory
	File "D:\WinTools\Media Tools\UniConvertor\*.*"

	SetOutPath "$INSTDIR\DLLs"
	;point your UniConvertor directory
	File "D:\WinTools\Media Tools\UniConvertor\DLLs\*.*"

	SetOutPath "$INSTDIR\Lib"
	;point your UniConvertor directory
	File /r /x test "D:\WinTools\Media Tools\UniConvertor\Lib\*.*"

	CreateDirectory "$SMPROGRAMS\${PROJECT}"
	CreateShortCut "$SMPROGRAMS\${PROJECT}\Cdr2PdfViewer Website.lnk" "http://github.com/stxh/cdr2pdfviewer"
	CreateShortCut "$SMPROGRAMS\${PROJECT}\卸载.lnk" "$INSTDIR\uninst.exe"

	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SOFT_NAME}" "DisplayName" ${SOFT_NAME}
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${SOFT_NAME}" "UninstallString" '"$INSTDIR\uninst.exe"'

	WriteUninstaller "uninst.exe"

	# later, inside a section:
	${registerExtension} "$INSTDIR\cdr2pdfviewer.exe" ".cdr" "CorelDRAW CDR Files(Cdr2PdfViewer)"
SectionEnd


;--------------------------------
;Uninstaller Section
;--------------------------------
Section "Uninstall"
	${unregisterExtension} ".cdr" "CorelDRAW CDR Files(Cdr2PdfViewer)"
  	RMDir /r "$SMPROGRAMS\${PROJECT}"
  	RMDir /r "$INSTDIR"
SectionEnd

