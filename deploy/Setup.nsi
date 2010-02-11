SetCompressor lzma
!include "MUI.nsh"

Name "Extension Changer 0.5"
BrandingText " "
ShowInstDetails Show
ShowUninstDetails Show
OutFile "extchanger.exe"
InstallDir "$PROGRAMFILES\Extension Changer"

!define MUI_ABORTWARNING ;when the user click cancel this will warn him
!define MUI_ICON "Icon.ico"
!define MUI_UNICON "Icon.ico"
!define REG_UNINSTALL "Software\Microsoft\Windows\CurrentVersion\Uninstall\Extension Changer"
!define MUI_FINISHPAGE_RUN  "$INSTDIR\extmain.exe"
!define MUI_FINISHPAGE_TEXT "Extension Changer has been installed on your computer.\r\n\r\nA new item (Edit The Extension) will now appear in the right-click menu for all files and folders in Explorer.\r\n\r\nClick Finish to close this wizard."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "Install"
  SetOutPath "$INSTDIR"
  File "C:\Yehia\Developement\Delphi\Extension Changer\extmain.exe"
  File "C:\Yehia\Developement\Delphi\Extension Changer\extcontext.dll"
  File "C:\Yehia\Developement\Delphi\Extension Changer\ReadMe.txt"
  SetOutPath "$INSTDIR\skins\"
  File "C:\Yehia\Developement\Delphi\Extension Changer\skins\aqua.bmp"
  File "C:\Yehia\Developement\Delphi\Extension Changer\skins\aqua.ini"
  File "C:\Yehia\Developement\Delphi\Extension Changer\skins\sadblue.bmp"
  File "C:\Yehia\Developement\Delphi\Extension Changer\skins\sadblue.ini"
  RegDLL "$INSTDIR\extcontext.dll"
  WriteRegStr HKCU "Software\Extension Changer" "Left" "100"
  WriteRegStr HKCU "Software\Extension Changer" "Top" "100"
  WriteRegStr HKCU "Software\Extension Changer" "ontop" "0"
  WriteRegStr HKCU "Software\Extension Changer" "cskin" "aqua.ini"
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayName" "Extension Changer"
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayIcon" "$INSTDIR\Extension Changer.exe"
  WriteRegStr HKLM "${REG_UNINSTALL}" "DisplayVersion" "0.5"
  WriteRegStr HKLM "${REG_UNINSTALL}" "Publisher" "Yehia A.Salam"
  WriteRegStr HKLM "${REG_UNINSTALL}" "UninstallString" "$INSTDIR\extuninstall.exe"
  WriteRegStr HKLM "${REG_UNINSTALL}" "URLInfoAbout" "http://www.yehiaeg.com"
  WriteRegStr HKLM "${REG_UNINSTALL}" "Contact" "extchanger@yehiaeg.com"
  WriteUninstaller "$INSTDIR\extuninstall.exe"
  CreateShortCut "$DESKTOP\Extension Changer.lnk" "$INSTDIR\extmain.exe"
SectionEnd


Section "Uninstall"
  UnRegDLL "$INSTDIR\extcontext.dll"
  Delete "$DESKTOP\Extension Changer.lnk"
  DeleteRegKey HKLM "${REG_UNINSTALL}"
  DeleteRegKey HKCU "Software\Extension Changer"
  RmDir /r "$INSTDIR"
SectionEnd
