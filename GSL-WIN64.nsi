# This installs the GSL libraries (compiled separately), builds an uninstaller, and
# adds uninstall information to the registry for Add/Remove Programs

!define APPNAME "gsl-2.7.1"
!define COMPANYNAME "GSL-WIN64"
!define DESCRIPTION "GNU Scientific Library"
# These three must be integers
!define VERSIONMAJOR 2
!define VERSIONMINOR 7
!define VERSIONBUILD 1.1c
# These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
# It is possible to use "mailto:" links in here to open the email client
!define HELPURL "https://lists.gnu.org/mailman/listinfo/help-gsl" # "Support Information" link
!define UPDATEURL "https://www.gnu.org/software/gsl/" # "Product Updates" link
!define ABOUTURL "https://www.gnu.org/software/gsl/doc/html/" # "Publisher" link
# This is the size (in kB) of all the files copied into "Program Files"
!define INSTALLSIZE 55624

RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)

InstallDir "$PROGRAMFILES64\${COMPANYNAME}\${APPNAME}"

# rtf or txt file - remember if it is txt, it must be in the DOS text format (\r\n)
LicenseData "LICENSE.txt"
# This will be in the installer/uninstaller's title bar
Name "${COMPANYNAME} - ${APPNAME}"
Icon "gnu_icon.ico"
outFile "GSL-WIN64.exe"

!include LogicLib.nsh
!addplugindir "."
# Just three pages - license agreement, install location, and installation
page license
page directory
Page instfiles

!macro VerifyUserIsAdmin
UserInfo::GetAccountType
pop $0
${If} $0 != "admin" ;Require admin rights on NT4+
        messageBox mb_iconstop "Administrator rights required!"
        setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
        quit
${EndIf}
!macroend

function .onInit
	setShellVarContext all
	!insertmacro VerifyUserIsAdmin
functionEnd

section "install"
	# Files for the install directory - to build the installer, these should be in the same directory as the install script (this file)
	setOutPath $INSTDIR
	# Files added here should be removed by the uninstaller (see section "uninstall")
	file "gnu_icon.ico"

	# Add any other files for the install directory (license files, app data, etc) here
	file /nonfatal /r "${APPNAME}\"

	# Uninstaller - See function un.onInit and section "uninstall" for configuration
	writeUninstaller "$INSTDIR\uninstall.exe"

	# Start Menu
	createDirectory "$SMPROGRAMS\${COMPANYNAME}"
	createShortCut "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}-doc.lnk" "$INSTDIR\share\info\gsl-ref.pdf "" "$INSTDIR\gnu_icon.ico"

	# Registry information for add/remove programs
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayName" "${COMPANYNAME} - ${APPNAME} - ${DESCRIPTION}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "InstallLocation" "$\"$INSTDIR$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayIcon" "$\"$INSTDIR\gnu_icon.ico$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}$\""
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "VersionMinor" ${VERSIONMINOR}
	# There is no option for modifying or repairing the install
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoModify" 1
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "NoRepair" 1
	# Set the INSTALLSIZE constant (!defined at the top of this script) so Add/Remove Programs can accurately report the size
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}" "EstimatedSize" ${INSTALLSIZE}

    # Update PATH environment variable to include location of GSL libs
    ; Set to HKLM
	EnVar::SetHKLM
	; Delete old values, if any
	EnVar::DeleteValue "Path" "%GSL_LIBRARY_PATH%\bin"
  	Pop $0
  	DetailPrint "EnVar::DeleteValue returned=|$0|"

  	EnVar::DeleteValue "Path" "%GSL_LIBRARY_PATH%\lib"
  	Pop $0
  	DetailPrint "EnVar::DeleteValue returned=|$0|"

  	EnVar::Delete "GSL_LIBRARY_PATH"
  	Pop $0
  	DetailPrint "EnVar::Delete returned=|$0|"

  	; Add the new values
  	EnVar::AddValue "GSL_LIBRARY_PATH" "$INSTDIR"
  	Pop $0
  	DetailPrint "EnVar::AddValue returned=|$0|"

  	EnVar::AddValue "PATH" "%GSL_LIBRARY_PATH%\bin"
  	Pop $0
  	DetailPrint "EnVar::AddValue returned=|$0|"

  	EnVar::AddValue "PATH" "%GSL_LIBRARY_PATH%\lib"
  	Pop $0
  	DetailPrint "EnVar::AddValue returned=|$0|"

sectionEnd

# Uninstaller

function un.onInit
	SetShellVarContext all

	#Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
functionEnd

section "uninstall"

	# Remove Start Menu launcher
	delete "$SMPROGRAMS\${COMPANYNAME}\${APPNAME}-doc.lnk"
	# Try to remove the Start Menu folder - this will only happen if it is empty
	rmDir "$SMPROGRAMS\${COMPANYNAME}"
	
	# Remove everything
	rmDir /r /REBOOTOK $INSTDIR\

	# Always delete uninstaller as the last action
	delete $INSTDIR\uninstall.exe

	# Remove uninstaller information from the registry
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${COMPANYNAME} ${APPNAME}"

	# Remove GSL lib location from PATH
	; Set to HKLM
	EnVar::SetHKLM
	EnVar::DeleteValue "Path" "%GSL_LIBRARY_PATH%\bin"
  	Pop $0
  	DetailPrint "EnVar::DeleteValue returned=|$0|"

  	EnVar::DeleteValue "Path" "%GSL_LIBRARY_PATH%\lib"
  	Pop $0
  	DetailPrint "EnVar::DeleteValue returned=|$0|"

  	EnVar::Delete "GSL_LIBRARY_PATH"
  	Pop $0
  	DetailPrint "EnVar::Delete returned=|$0|"
sectionEnd
