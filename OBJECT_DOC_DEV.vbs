' $Workfile: OBJECTDEF.SCRIPT.OBJECT_DOC_DEV.scr $ 
' $Date: 30.01.07 19:38 $ 
' $Revision: 1 $ 
' $Author: Oreshkin $ 
'
' Разрабатываемый документ
'------------------------------------------------------------------------------
' Авторское право c ЗАО <НАНОСОФТ>, 2008 г.

USE "OBJECT_DOC"
USE "CMD_DLL_ROLES"
USE CMD_SS_SYSADMINMODE

USE "CMD_RENAME_FILES"

Sub Object_BeforeCreate(Obj, Parent, Cancel)
  
  ' Если пользователь и ответственный по комплекту/Тому из разных отделов, то не даем создавать чертеж
  ' По протоколу Тюмени п. 6.2.11
  If Parent.IsKindOf("OBJECT_WORK_DOCS_FOR_BUILDING") = False Then 
    chk =ThisApplication.ExecuteScript ("CMD_PROJECT_DOCS_LIBRARY","DocCreatePermissionsCheck",Obj,Parent)
  Else
    chk = True
  End If
  
  If chk = False Then
    Cancel = True
    Exit Sub
  End If
  
  sysID = ThisApplication.ExecuteScript ("CMD_KD_REGNO_KIB","Get_Sys_Id",Obj)
  if sysID = 0 then 
      Cancel = true
      exit sub
  else  
    Obj.Attributes("ATTR_KD_IDNUMBER").value = sysID
  end if
  
  Call ThisApplication.ExecuteScript("CMD_ROUTER","Run",Parent,Parent.Status,Obj,Obj.ObjectDef.InitialStatus)
  Call ThisApplication.ExecuteScript("CMD_DLL_ROLES","SetDocDevAppoint",Obj)
  Call SetStartAttrs(Obj, Parent)
  If Parent.IsKindOf("OBJECT_WORK_DOCS_FOR_BUILDING") = False Then _
  Call ThisApplication.ExecuteScript ("CMD_PROJECT_DOCS_LIBRARY","SetCheckList",Obj, Parent)
End Sub



'Sub Object_Modified(Obj)
'  ThisApplication.ExecuteScript "CMD_DLL", "SetIcon", Obj
'End Sub

Sub Object_Created(Obj, Parent)
  'Obj.Permissions = SysAdminPermissions
  'Просим добавить файл
  'If Obj.Files.Count = 0 Then
  '  Call ThisApplication.ExecuteScript("CMD_S_DLL", "AddFileToObj", Obj,False)
  'End If
End Sub

'Sub Object_CheckedIn(Obj)
'  'Запись в журнал сессиий - Загружен
'  ThisApplication.ExecuteScript "CMD_DLL", "TsessionRowCreate", Obj, True
'End Sub

'Sub Object_BeforeCheckOut(Obj, Cancel)
'  'Запись в журнал сессиий - Выгружен
'  ThisApplication.ExecuteScript "CMD_DLL", "TsessionRowCreate", Obj, False
'End Sub

Sub Object_StatusChanged(Obj, Status)
  If Status is Nothing Then Exit Sub
  ThisScript.SysAdminModeOn
  
  'Определение статуса после согласования
  StatusAfterAgreed = ""
  Set Rows = ThisApplication.Attributes("ATTR_AGREENENT_SETTINGS").Rows
  For Each Row in Rows
    If Row.Attributes("ATTR_KD_OBJ_TYPE").Value = Obj.ObjectDefName Then
      StatusAfterAgreed = Row.Attributes("ATTR_KD_FINISH_STATUS")
      StatusReturnAfterAgreed = Row.Attributes("ATTR_KD_RETURN_STATUS")
      Exit For
    End If
  Next
  'Отработка маршрутов для механизма согласования
  If Status.SysName = "STATUS_KD_AGREEMENT" or Status.SysName = StatusAfterAgreed Then
    If Obj.Dictionary.Exists("PrevStatusName") Then
      sName = Obj.Dictionary.Item("PrevStatusName")
      If ThisApplication.Statuses.Has(sName) Then
        Set PrevSt = ThisApplication.Statuses(sName)
        Call ThisApplication.ExecuteScript("CMD_ROUTER","RunNonStatusChange",Obj,PrevSt,Obj,Status.SysName) 
      End If
    End If
  End If
  ' Постобработка согласования при отклонении документа
  If Obj.Dictionary.Exists("PrevStatusName") Then
    sName = Obj.Dictionary.Item("PrevStatusName")
    If sName = "STATUS_KD_AGREEMENT" Then 'And Status.SysName = StatusReturnAfterAgreed Then
      Call ThisApplication.ExecuteScript("CMD_PROJECT_DOCS_LIBRARY","AgreementPostProcess",Obj) 
    End If
  End If
End Sub

Sub Object_StatusBeforeChange(Obj, Status, Cancel)
  ThisScript.SysAdminModeOn
  'Записываем текущий статус в словарь
  Obj.Dictionary.Item("PrevStatusName") = Obj.StatusName
End Sub

function Check_FinishStatus(stName)
  Check_FinishStatus = (stName = "STATUS_DOCUMENT_INVALIDATED")
end function

'=============================================
function GetTypeFileArr(docObj)
  Set CU = thisApplication.CurrentUser
  
    isAuth = ThisApplication.ExecuteScript("CMD_DLL_ROLES","IsAuthor",docObj,CU)
    isDevl = ThisApplication.ExecuteScript("CMD_DLL_ROLES","IsDeveloper",docObj,CU)
    isChck = ThisApplication.ExecuteScript("CMD_DLL_ROLES","IsChecker",docObj,CU)
    isInit = ThisApplication.ExecuteScript("CMD_DLL_ROLES","IsInitiator",docObj,CU)
    isAprv = ThisApplication.ExecuteScript("CMD_DLL_ROLES","IsAprover",docObj,CU)
    isNkr = ThisApplication.ExecuteScript("CMD_DLL_ROLES","isNCUser",docObj,CU)
    isCanAppr = ThisApplication.ExecuteScript("CMD_KD_USER_PERMISSIONS","IsCanAprove",CU,docObj)
    
  st = docObj.StatusName
  select case st
    case "STATUS_DOC_IS_ADDED","STATUS_DOCUMENT_CREATED"
      if isAuth or isDevl  then _
          GetTypeFileArr = array("Документ","Таблица","Файл","Скан документа")  
    case "STATUS_DOCUMENT_CHECK"
      if isChck then _
          GetTypeFileArr = array("Файл","Скан документа")  
    case "STATUS_DOCUMENT_DEVELOPED"
      if isInit then _
          GetTypeFileArr = array("Файл","Скан документа")  
    case "STATUS_DOCUMENT_IS_TAKEN_NK"
      if isNkr then _
          GetTypeFileArr = array("Файл","Скан документа")  
    case "STATUS_KD_AGREEMENT"
      if isSin or isCanAppr then _
          GetTypeFileArr = array("Файл","Скан документа")  
    case "STATUS_DOCUMENT_AGREED"
      if isAuth or isDevl then _
          GetTypeFileArr = array("Файл","Скан документа")        
    case "STATUS_DOCUMENT_IS_APPROVING"
      if isAprv then _
          GetTypeFileArr = array("Файл","Скан документа")  
    case "STATUS_DOCUMENT_FIXED"
  end select
end function

Sub ContextMenu_BeforeShow(Commands, Obj, Cancel)
  If Obj.ObjectDefName <> "OBJECT_DRAWING" Then
    Commands.Remove ThisApplication.Commands("CMD_LINK_TO_DRAWING_CREATE")
  End If
End Sub

function CopyAttrsFromDocBase(newObj, docBase)
  CopyAttrsFromDocBase = False
  If newObj Is Nothing or docBase Is Nothing Then Exit Function
  
  Set oProj = docBase.Attributes("ATTR_PROJECT").Object
  
  Set Gip = oProj.Attributes("ATTR_PROJECT_GIP").User
  
  If Not oProj Is Nothing Then 
    Set oContr = oProj.Attributes("ATTR_CONTRACT").Object
  End If
  
  Set Table = NewObj.Attributes("ATTR_KD_TLINKPROJ")
  Set NewRow = Table.Rows.Create

  
  ThisApplication.ExecuteScript "CMD_DLL", "SetAttr_F",newObj, "ATTR_KD_AGREENUM", oContr, False
  ThisApplication.ExecuteScript "CMD_DLL", "SetAttr_F",NewRow, "ATTR_KD_LINKPROJ", oProj, False
  ThisApplication.ExecuteScript "CMD_DLL", "SetAttr_F",NewRow, "ATTR_KD_GIP", Gip, False
  
  CopyAttrsFromDocBase = True
end function


Sub SetStartAttrs(Obj, Parent)
  'Формируем обозначение Проектного документа
  If ThisApplication.ExecuteScript("CMD_S_NUMBERING", "DocDevCodeGenCheck",Obj) = True Then
    Call ThisApplication.ExecuteScript("CMD_PROJECT_DOCS_LIBRARY", "CodeGen",Obj)
'    Obj.Attributes("ATTR_DOC_CODE") = ThisApplication.ExecuteScript("CMD_S_NUMBERING", "DocDevCodeGen",Obj)
  End If
  
  aList = "ATTR_CHECK_LIST"
  Call ThisApplication.ExecuteScript("CMD_DLL", "AttrsSyncBetweenObjs", Parent,Obj,aList)
End Sub

