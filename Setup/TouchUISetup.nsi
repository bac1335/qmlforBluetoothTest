; �ýű�ʹ�� HM VNISEdit �ű��༭���򵼲���
!include "nsDialogs.nsh"
!include "LogicLib.nsh"
!include "FileFunc.nsh"
!include "Sections.nsh"
!include "WordFunc.nsh"

; ��װ�����ʼ���峣��
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

; ------ MUI �ִ����涨�� (1.67 �汾���ϼ���) ------
!include "MUI.nsh"

; MUI Ԥ���峣��
!define MUI_ABORTWARNING
!define MUI_ICON "setup.ico"
!define MUI_UNICON "setup.ico"
!define PRODUCT_CLOUDBOARD_KEY_MAIN "Software\llssoft\${PRODUCT_NAME}"
; ����ѡ�񴰿ڳ�������
!define MUI_LANGDLL_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_LANGDLL_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_LANGDLL_REGISTRY_VALUENAME "NSIS:Language"


; ��ӭҳ��
!insertmacro MUI_PAGE_WELCOME

; ���Э��ҳ��
;!insertmacro MUI_PAGE_LICENSE $(MSG_LICENSE)
; Ƕ���齨ѡ��ҳ��
!insertmacro MUI_PAGE_COMPONENTS
; ��װĿ¼ѡ��ҳ��
!insertmacro MUI_PAGE_DIRECTORY
; ��װ����ҳ��
!insertmacro MUI_PAGE_INSTFILES
; ��װ���ҳ��
!insertmacro MUI_PAGE_FINISH

; ��װж�ع���ҳ��
!insertmacro MUI_UNPAGE_INSTFILES

; ��װ�����������������
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "SimpChinese"

;LicenseLangString MSG_LICENSE ${LANG_ENGLISH} ".\License_en.txt"
;LicenseLangString MSG_LICENSE ${LANG_SIMPCHINESE} ".\licence.txt"


LangString CURLAN ${LANG_ENGLISH} "en"
LangString CURLAN ${LANG_SIMPCHINESE} "cn"
LangString ProgLinkName ${LANG_SIMPCHINESE}  ${PRODUCT_NAME} ;
LangString ProgLinkName ${LANG_ENGLISH} ${PRODUCT_NAME}
LangString UninstallBeforeInstall ${LANG_SIMPCHINESE} "��⵽ϵͳ�Ѿ���װ�� ${PRODUCT_NAME} ��$\r$\n����֮ǰ������ִ��ж��,������?"
LangString UninstallBeforeInstall ${LANG_ENGLISH} "${PRODUCT_NAME} already installed $\r$\n we must uninstall it before continuing the setup. continue?"
LangString SureToRemoveInstall ${LANG_SIMPCHINESE} "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������"
LangString SureToRemoveInstall ${LANG_ENGLISH} "Are you sure to completely remove $(^Name) and all its components?"
LangString SuccesslyRemoved ${LANG_SIMPCHINESE} "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
LangString SuccesslyRemoved ${LANG_ENGLISH} "$(^Name) has been successfully removed from your computer."

; ��װԤ�ͷ��ļ�
!insertmacro MUI_RESERVEFILE_LANGDLL
!insertmacro MUI_RESERVEFILE_INSTALLOPTIONS
; ------ MUI �ִ����涨����� ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "${PRODUCT_NAME} V${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
ShowInstDetails show
ShowUnInstDetails show
;BrandingText "Cloud - TouchUI v${PRODUCT_VERSION}"

Section "������" SEC01
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


#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#


Function .onInit
System::Call 'kernel32::CreateMutexA(i 0, i 0, t "C4Setup") i .r1 ?e'
 Pop $R0

 StrCmp $R0 0 +3
   MessageBox MB_OK|MB_ICONEXCLAMATION "��װ�����Ѿ������С�"
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
  # ��Ĭж��
 ; IfSilent 0 onInit.RunUnst ���ڲ����Ƿ�Ĭ����Ĭж�����а汾
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
 *  �����ǰ�װ�����ж�ز���  *
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
  ;MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���" ���У�������
  RMDir /r "$INSTDIR"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_CLOUDBOARD_KEY_MAIN}"
  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  SetAutoClose true
SectionEnd

#-- ���� NSIS �ű��༭�������� Function ���α�������� Section ����֮���д���Ա��ⰲװ�������δ��Ԥ֪�����⡣--#



Function un.onInit
!insertmacro MUI_UNGETLANGUAGE
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "��ȷʵҪ��ȫ�Ƴ� $(^Name) ���������е������" IDYES +2
  Abort

   Push $0
  ReadRegStr $0 HKLM ${PRODUCT_REINSTALL_KEY} ""
  StrCmp $0 "" un.onUnEnd
  ReadRegStr $1 HKLM ${PRODUCT_REINSTALL_KEY} "params"
  # ���۲�����ʲô, ȫ����ȡע�����
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
  ;MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) �ѳɹ��ش����ļ�����Ƴ���"
FunctionEnd
