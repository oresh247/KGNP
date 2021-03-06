' Команда - Вернуть документ на доработку
'------------------------------------------------------------------------------
' Автор: Чернышов Д.С.
' Авторское право © АО «СИСОФТ», 2017 г.

Res = Main(ThisObject)

Function Main(Obj)
  Main = False
  ThisScript.SysAdminModeOn
  Set CU = ThisApplication.CurrentUser
  
  'Проверка состояния
  If Obj.Status is Nothing Then Exit Function
  result = CheckStatusTransition(Obj)
  If result > 0 Then 
    Set p = Obj.Parent
    Set stat = p.Status
    If Not stat Is Nothing Then
      sName = p.Status.Description
    End If
    If p.ObjectDefName = "OBJECT_VOLUME" Then
      NextStatus = "STATUS_VOLUME_IS_BUNDLING"
      Scr = "CMD_VOLUME_BACK_TO_COR"
    ElseIf p.ObjectDefName = "OBJECT_WORK_DOCS_SET" Then
      NextStatus = "STATUS_WORK_DOCS_SET_IS_DEVELOPING"
      Scr = "CMD_WORK_DOCS_SET_BACK_TO_COR"
    End If
    txt = """" & Obj.Parent.Description & """ находится в статусе " & sName & ". " & chr(10) &_
            "Будет установлен статус: """ & ThisApplication.Statuses(NextStatus).Description & """" &_
                  chr(10) & "Продолжить?"
    ans = msgbox(txt,vbQuestion+vbYesNo,"Вернуть на доработку")
    If ans <> vbYes Then Exit Function
    Call ThisApplication.ExecuteScript(Scr,"Run",Obj)
  ElseIf result < 0 Then
    Exit Function
  End If
  
  'Запрос причины
  result = ThisApplication.ExecuteScript("CMD_KD_COMMON_LIB","GetComment","Укажите причину возврата документа:")
  If IsEmpty(result) Then
    Exit Function 
  ElseIf trim(result) = "" Then
    msgbox "Невозможно вернуть документ не указав причину." & vbNewLine & _
        "Пожалуйста, введите причину возврата.", vbCritical, "Не задана причина возврата!"
    Exit Function
  End If
  
  If Obj.StatusName = "STATUS_DOCUMENT_CHECK" Then
    resol = "NODE_KD_CHECK"
  ElseIf Obj.StatusName = "STATUS_DOCUMENT_IS_APPROVING" Then
    resol = "NODE_KD_SING"
  ElseIf Obj.StatusName = "STATUS_DOCUMENT_IS_TAKEN_NK" Then 
    resol = "NODE_CORR_INSPECTION"
  End If         
  
  'Заполнение причины возвращения
  Set Rows = Obj.Attributes("ATTR_CHECK_LIST").Rows
  For Each Row in Rows
    If Row.Attributes("ATTR_USER").Empty = False Then
      If not Row.Attributes("ATTR_USER").User is Nothing Then
        If Row.Attributes("ATTR_USER").User.SysName = CU.SysName Then
          Row.Attributes("ATTR_RESOLUTION").Classifier = _
            ThisApplication.Classifiers.FindBySysId("NODE_REJECT")
          Row.Attributes("ATTR_DATA").Value = Date
          Row.Attributes("ATTR_T_REJECT_REASON").Value = result
        End If
      End If
    End If
  Next
  
  'Создание версии
  Obj.Versions.Create ,result
  
  
  
  
  '=======================================================
  ' Перенес в ClearCheckList в CMD_PROJECT_DOCS_LIBRARY
'  Set Table = Obj.Attributes("ATTR_CHECK_LIST")
'  
'  For each row In Table.rows
'    If Not row Is Nothing Then
'      ThisApplication.ExecuteScript "CMD_SS_LIB", "ClearAttributes", _
'        row, "ATTR_DATA;ATTR_RESOLUTION;ATTR_T_REJECT_REASON"
'    End If
'  Next
  '========================================================
  
  
  
'  Dim row
'  Set row = ThisApplication.ExecuteScript("CMD_SS_LIB", "FindCheckListRow", Obj, CU)
'  If Not row Is Nothing Then
'    ThisApplication.ExecuteScript "CMD_SS_LIB", "ClearAttributes", _
'      Obj, "ATTR_DATA;ATTR_RESOLUTION;ATTR_T_REJECT_REASON"
'  End If
  
  
  Call Run(Obj)
  
  ' Закрываем поручение
  Call ThisApplication.ExecuteScript("CMD_DLL_ORDERS","RejectOrderByResol",Obj,resol)
  
  ' Оповещение 
  Call SendMessage(Obj)
  Call SendOrder(Obj)
  Main = True
End Function

Sub Run(Obj)
  Obj.Permissions = SysAdminPermissions
  ' Очищаем таблицу проверки
  Call ThisApplication.ExecuteScript("CMD_PROJECT_DOCS_LIBRARY","ClearCheckList",Obj)

  ' Сбрасываем атрибут дата разработки
  ThisApplication.ExecuteScript "CMD_SS_LIB", "ClearAttributes", Obj, "ATTR_DEVELOP_DATE"

  'Изменение статуса документа
  StatusName = "STATUS_DOCUMENT_CREATED"
  RetVal = ThisApplication.ExecuteScript("CMD_ROUTER", "Run",Obj,Obj.Status,Obj,StatusName)
  If RetVal = -1 Then
    Obj.Status = ThisApplication.Statuses(StatusName)
  End If
End Sub

'==============================================================================
' Отправка оповещения о возвращении документа в разработку всем разработчикам
' и соавторам
'------------------------------------------------------------------------------
' o_:TDMSObject - возвращенный в разработку документ
'==============================================================================
Private Sub SendMessage(o_)
  Dim u
  For Each r In o_.RolesByDef("ROLE_DOC_DEVELOPER")
    If Not r.User Is Nothing Then
      Set u = r.User
    End If
    If Not r.Group Is Nothing Then
      Set u = r.Group
    End If
    ThisApplication.ExecuteScript "CMD_MESSAGE", "SendMessage", 1506, u, o_, Nothing, o_.ObjectDef.Description,o_.Description, ThisApplication.CurrentUser.Description,o_.VersionDescription
  Next
  For Each r In o_.RolesByDef("ROLE_CO_AUTHOR")
    If Not r.User Is Nothing Then
      Set u = r.User
    End If
    If Not r.Group Is Nothing Then
      Set u = r.Group
    End If
    ThisApplication.ExecuteScript "CMD_MESSAGE", "SendMessage", 1506, u, o_, Nothing, o_.ObjectDef.Description,o_.Description, ThisApplication.CurrentUser.Description,o_.VersionDescription
  Next  
End Sub

'==============================================================================
' Функция проверяет условие перехода по статусам
'------------------------------------------------------------------------------
' o_:TDMSObject - Системный идентификатор обрабатываемого ИО
' CheckStatusTransition:Integer - Результат проверки 
'       (0:Проверка успешна,№ - номер ошибки (сообщения))
'==============================================================================
Private Function CheckStatusTransition(o_)
  CheckStatusTransition = -1
  If o_.Parent is Nothing Then Exit Function
  ' Проверка статуса раздела
  Set p = o_.Parent
'  If p.ObjectDefName = "OBJECT_PROJECT_SECTION" And p.StatusName <> "STATUS_PROJECT_SECTION_IS_DEVELOPING" Then
'    CheckStatusTransition = 1177
'    ThisApplication.ExecuteScript "CMD_MESSAGE", "ShowWarning", vbInformation, CheckStatusTransition, o_.ObjectDef.Description,o_.Description    
'    Exit Function
'  End If
'  If p.ObjectDefName = "OBJECT_PROJECT_SECTION_SUBSECTION" And p.StatusName <> "STATUS_PROJECT_SECTION_IS_DEVELOPING" Then
'    CheckStatusTransition = 1178
'    ThisApplication.ExecuteScript "CMD_MESSAGE", "ShowWarning", vbInformation, CheckStatusTransition, o_.ObjectDef.Description,o_.Description    
'    Exit Function
'  End If
  If p.ObjectDefName = "OBJECT_WORK_DOCS_SET" And p.StatusName <> "STATUS_WORK_DOCS_SET_IS_DEVELOPING" Then
    CheckStatusTransition = 1179
  '  ThisApplication.ExecuteScript "CMD_MESSAGE", "ShowWarning", vbInformation, CheckStatusTransition, o_.ObjectDef.Description,o_.Description    
    Exit Function
  End If  
  If p.ObjectDefName = "OBJECT_VOLUME" And p.StatusName <> "STATUS_VOLUME_IS_BUNDLING" Then
    CheckStatusTransition = 1200
   ' ThisApplication.ExecuteScript "CMD_MESSAGE", "ShowWarning", vbInformation, CheckStatusTransition, o_.Description    
    Exit Function
  End If  
  CheckStatusTransition = 0
End Function


'==============================================================================
' Отправка поручение на доработку задания
' разработчику задания 
'------------------------------------------------------------------------------
' o_:TDMSObject - разработанное задание
'==============================================================================
Sub SendOrder(Obj)
  Call ThisApplication.ExecuteScript("CMD_DLL_ORDERS","SendOrder_NODE_KD_RETUN_USER",Obj)
'  If Obj.Attributes.Has("ATTR_AUTOR") Then
'    If Not Obj.Attributes("ATTR_AUTOR").Empty Then
'      Set uToUser = Obj.Attributes("ATTR_AUTOR").User
'      If uToUser Is Nothing Then Exit Sub
''      ThisApplication.ExecuteScript "CMD_KD_ORDER_LIB", "CreateSystemOrder", _
''        Obj, "OBJECT_KD_ORDER_NOTICE", Obj.Attributes("ATTR_AUTOR").User, _
''        ThisApplication.CurrentUser, "NODE_CORR_REZOL_INF", result, ""
'    End If
'  ElseIf Obj.Attributes.Has("ATTR_RESPONSIBLE") Then
'    If Not Obj.Attributes("ATTR_RESPONSIBLE").Empty Then
'      Set uToUser = Obj.Attributes("ATTR_RESPONSIBLE").User
'      If uToUser Is Nothing Then Exit Sub
'    End If
'  End If
'  
'  Set uFromUser = ThisApplication.CurrentUser
'  resol = "NODE_KD_RETUN_USER"
'  txt = "Документ """ & Obj.Description & """ Причина: " & Obj.VersionDescription
'  planDate = DateAdd ("d", 1, Date) 'Date + 1
'  ThisApplication.ExecuteScript "CMD_KD_ORDER_LIB","CreateSystemOrder",Obj,"OBJECT_KD_ORDER_NOTICE",uToUser,uFromUser,resol,txt,planDate
End Sub

