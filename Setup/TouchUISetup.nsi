; 该脚本使用 HM VNISEdit 脚本编辑器向导产生
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "Sections.nsh"
!include "WordFunc.nsh"

; 安装程序初始定义常量
!define PRODUCT_NAME "facedetection" ;
!define PRODUCT_VERSION "1.0.1"
!define PRODUCT_PUBLISHER ""
!define PRODUCT_WEB_SITE ""
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_REINSTALL_KEY "Software\llssoft\c4-installer"
!define PRODUCT_REINSTALL_START_KEY "Software\Microsoft\Windows\CurrentVersion\Run"
!define TOUCHWINGESTURE_VERSION "1.0"

SetCompressor lzma

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"

; MUI 预定义常量
!define MUI_ABORTWARNING
!define MUI_ICON "setup.ico"
!define MUI_UNICON "setup.ico"
!define PRODUCT_CLOUDBOARD_KEY_MAIN "Software\llssoft\${PRODUCT_NAME}"
; 语言选择窗口常量设置
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"


; 欢迎页面
!insertmacro MUI_PAGE_WELCOME

; 许可协议页面
;!insertmacro MUI_PAGE_LICENSE $(MSG_LICENSE)
; 嵌入组建选择页面
!insertmacro MUI_PAGE_COMPONENTS
; 安装目录选择页面
!insertmacro MUI_PAGE_DIRECTORY
; 安装过程页面
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
!insertmacro MUI_PAGE_FINISH

; 安装卸载过程页面
!insertmacro MUI_UNPAGE_INSTFILES

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"

;LicenseLangString MSG_LICENSE ${LANG_ENGLISH} ".\License_en.txt"
;LicenseLangString MSG_LICENSE ${LANG_SIMPCHINESE} ".\licence.txt"


LangString CURLAN ${LANG_ENGLISH} "en"
LangString CURLAN ${LANG_SIMPCHINESE} "cn"
LangString ProgLinkName ${LANG_SIMPCHINESE}  ${PRODUCT_NAME} ;
LangString ProgLinkName ${LANG_ENGLISH} ${PRODUCT_NAME}
LangString UninstallBeforeInstall ${LANG_SIMPCHINESE} "检测到系统已经安装了 ${PRODUCT_NAME} 。$\r$\n继续之前必须先执行卸载,继续吗?"
LangString UninstallBeforeInstall ${LANG_ENGLISH} "${PRODUCT_NAME} already installed $\r$\n we must uninstall it before continuing the setup. continue?"
LangString SureToRemoveInstall ${LANG_SIMPCHINESE} "您确实要完全移除 $(^Name) ，及其所有的组件？"
LangString SureToRemoveInstall ${LANG_ENGLISH} "Are you sure to completely remove $(^Name) and all its components?"
LangString SuccesslyRemoved ${LANG_SIMPCHINESE} "$(^Name) 已成功地从您的计算机移除。"
LangString SuccesslyRemoved ${LANG_ENGLISH} "$(^Name) has been successfully removed from your computer."

; 安装预释放文件
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI 现代界面定义结束 ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} V${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show
;BrandingText "Cloud - TouchUI v${PRODUCT_VERSION}"

Section "主程序" SEC01
SectionIn RO

  SetOutPath "$INSTDIR"
  
	;AccessControl::GrantOnFile \ "$INSTDIR" "everyone" "GenericRead + GenericWrite"
    
  	SetOverwrite ifnewer
  	File /r "${PRODUCT_NAME}\*.*"


SectionEnd



Section "VCRedist2010" SecVC2010
  SetOutPath "$INSTDIR\runtime"
    SetOverwrite on
  SetCompress off
  File "runtime\vcredist_x86_2010_sp1.exe"
	Exec "$INSTDIR\runtime\vcredist_x86_2010_sp1.exe /q"
SectionEnd

Section -AdditionalIcons
	SetOutPath "$INSTDIR"
  ;WriteIniStr "$INSTDIR\TimeLink.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"

	CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  ;CreateShortCut "$SMPROGRAMS\TimeLink\TouchUI\TimeLink.lnk" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_NAME}.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd


#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#


Function .onInit
System::Call 'kernel32::CreateMutexA(i 0, i 0, t "C4Setup") i .r1 ?e'
 Pop $R0

 StrCmp $R0 0 +3
   MessageBox MB_OK|MB_ICONEXCLAMATION "安装程序已经在运行。"
   Abort

Push $0
  Push $1
  ReadRegStr $0 HKLM ${PRODUCT_UNINST_KEY} "UninstallString"
  StrCmp $0 "" onInit.End
  IfFileExists $0 0 onInit.End
  MessageBox MB_YESNO|MB_ICONQUESTION $(UninstallBeforeInstall) /SD IDYES IDNO onInit.GoAbort
  KillProcDLL::KillProc "C4UIMainWidget.exe"
  system::call 'Kernel32::GetModuleFileNameA(i 0,t .r1,i 256)i'
  WriteRegStr HKLM ${PRODUCT_REINSTALL_KEY} "" $1
;  WriteRegStr HKLM ${PRODUCT_REINSTALL_KEY} "params" $CmdParams
  # 静默卸载
 ; IfSilent 0 onInit.RunUnst 现在不管是否静默都静默卸载已有版本
  StrCpy $0 '"$0" /S'
	ExecWait $0
	Goto onInit.GoAbort
onInit.RunUnst:
		ExecWait $0
onInit.GoAbort:
    Abort
	onInit.End:
  Pop $1
  Pop $0
  
  !insertmacro MUI_LANGDLL_DISPLAY
FunctionEnd

Function .onInstSuccess
   WriteRegStr HKLM "${PRODUCT_CLOUDBOARD_KEY_MAIN}" "" $INSTDIR
   WriteRegStr HKLM "${PRODUCT_CLOUDBOARD_KEY_MAIN}" "CurrVersion" ${PRODUCT_VERSION}
   
FunctionEnd

/******************************
 *  以下是安装程序的卸载部分  *
 ******************************/

Section Uninstall
  Delete "$INSTDIR\${PRODUCT_NAME}.url"
  Delete "$INSTDIR\uninst.exe"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  SetShellVarContext all


  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  ;Delete "$SMPROGRAMS\${PRODUCT_NAME}"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk"
  Delete "$INSTDIR\uninst.exe"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\Uninstall"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  
  SetShellVarContext current
	;MessageBox MB_ICONINFORMATION|MB_OK "${PRODUCT_NAME} $OLD_VER : Uninstalled successfully ."
  ;MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。" 不行，出问题
  RMDir /r "$INSTDIR"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_CLOUDBOARD_KEY_MAIN}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd

#-- 根据 NSIS 脚本编辑规则，所有 Function 区段必须放置在 Section 区段之后编写，以避免安装程序出现未可预知的问题。--#



Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "您确实要完全移除 $(^Name) ，及其所有的组件？" IDYES +2
  Abort

   Push $0
  ReadRegStr $0 HKLM ${PRODUCT_REINSTALL_KEY} ""
  StrCmp $0 "" un.onUnEnd
  ReadRegStr $1 HKLM ${PRODUCT_REINSTALL_KEY} "params"
  # 不论参数是什么, 全部读取注册表即可
  StrCpy $0 '"$0" $1'
  #IfSilent 0 un.onUnSExec
  #Exec $0
  #Goto un.onUnEnd
	#un.onUnSExec:
  Exec $0
  un.onUnEnd:
  DeleteRegKey HKLM ${PRODUCT_REINSTALL_KEY}
  ;DeleteRegValue HKLM ${PRODUCT_REINSTALL_START_KEY} "jxzc"

  Pop $0
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  Delete "$DOCUMENTS\NewConfig"
  DetailPrint "End MB_OK"
  ;MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) 已成功地从您的计算机移除。"
FunctionEnd
