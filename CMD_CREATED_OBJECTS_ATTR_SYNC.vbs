' Команда - Синхронизировать атрибуты объектов
'------------------------------------------------------------------------------
' Автор: Чернышов Д.С.
' Авторское право © АО «СИСОФТ», 2017 г.

Call Main

Sub Main()
  ThisScript.SysAdminModeOn
  Set Dlg = ThisApplication.Dialogs.SelectDlg
  Dlg.SelectFrom = ThisApplication.ObjectDefs
  Dlg.Prompt = "Выберите типы объектов для синхронизации атрибутов"
  Dlg.Caption = "Синхронизация атрибутов"
  Dlg.UseCheckBoxes = True
  If Dlg.Show = False Then Exit Sub
  If Dlg.Objects.Count = 0 Then Exit Sub
  Set ObjDefs = Dlg.Objects
  
  Key = Msgbox("Внимание! Такая процедура удалит лишние и добавит недостающие атрибуты у существующих объектов." &_
  chr(10) & "Перед выполнением обязательно сделайте бекап БД." &_
  chr(10) & chr(10) & "Произвести обновление атрибутов?", vbExclamation+vbYesNo)
  If Key = vbNo Then Exit Sub
  ThisApplication.Utility.WaitCursor = True
  Set Progress = ThisApplication.Dialogs.ProgressDlg
  Progress.Start
  
  ObjDefCount = 0
  Stp = 0
  Stp0 = 0
  oCount = ObjDefs.Count
  For Each ObjDef in ObjDefs
    ObjDefCount = ObjDefCount + ObjDef.Objects.Count
  Next
  If ObjDefCount > 0 Then Stp = 100 / ObjDefCount
  ObjDefCount = 0
  Set Dict = ThisApplication.Dictionary("GlobalAttrSync")
  Dict.RemoveAll
  
  For Each ObjDef in ObjDefs
    ObjDefCount = ObjDefCount + 1
    str = "("&ObjDefCount&" из "&oCount&") Обновление атрибутов у объектов типа """&ObjDef.Description&""""
    Progress.Text = str
    ObjCount = ObjDef.Objects.Count
    If ObjCount > 0 Then Stp1 = 100 / ObjCount
    Result = ""
    CountDel = 0
    CountAdd = 0
    For Each Obj in ObjDef.Objects
      ObjGuid = Obj.Guid
      Stp0 = Stp0 + Stp
      Progress.Position = Stp0
      'Процедура обновления атрибутного состава объекта
      If Dict.Exists(ObjGuid) = False Then
        Call AttrsSync(Obj,CountDel,CountAdd)
        Dict.Item(ObjGuid) = True
      End If
    Next
    If CountDel <> 0 or CountAdd <> 0 Then
      Result = "Объекты типа """ & ObjDef.Description & """:"
      If CountDel <> 0 Then
        Result = Result & chr(10) & "  удалено " & CountDel & " атрибутов."
      End If
      If CountAdd <> 0 Then
        Result = Result & chr(10) & "  добавлено " & CountAdd & " атрибутов."
      End If
      ThisApplication.AddNotify Result
    End If
  Next
  
  Dict.RemoveAll
  ThisApplication.AddNotify "Обновление атрибутов завершено."
  Progress.Stop
  ThisApplication.Utility.WaitCursor = False
End Sub

Sub AttrsSync(Obj,CountDel,CountAdd)
  Set ObjDef = Obj.ObjectDef
  Select Case ObjDef.SysName
    'Документ закупки
    Case "OBJECT_PURCHASE_DOC---"
      AttrName = "ATTR_PURCHASE_DOC_TYPE"
      Check = False
      If Obj.Attributes.Has(AttrName) and not Obj.Parent is Nothing Then
        If Obj.Attributes(AttrName).Empty = False Then
          Val = Obj.Attributes(AttrName).Value
          If StrComp(Val,"Информационная карта",vbTextCompare) <> 0 Then
            For Each Attr in Obj.Parent.Attributes
              SysName = Attr.AttributeDefName
              If Obj.Attributes.Has(SysName) and SysName <> "ATTR_TENDER_INVITATION_COUNT_EIS" And SysName <> "ATTR_KD_IDNUMBER" Then
                Obj.Attributes.Remove Obj.Attributes(SysName)
              End If
            Next
          Else
            Check = True
          End If
        Else
          Check = True
        End If
      Else
        Check = True
      End If
      If Check = True Then
        Call AttrsDelAdd(Obj,ObjDef,CountDel,CountAdd)
      End If
      
    'Правило по умолчанию
    Case Else
      Call AttrsDelAdd(Obj,ObjDef,CountDel,CountAdd)
  End Select
End Sub

Sub AttrsDelAdd(Obj,ObjDef,CountDel,CountAdd)
  'Удаление лишних атрибутов
  For Each AttrObj in Obj.Attributes
  If AttrObj.Empty = False Then
    If ObjDef.AttributeDefs.Has(AttrObj.AttributeDefName) = False Then
      Obj.Attributes.Remove AttrObj
      CountDel = CountDel + 1
    Else
      Call AttrFill(Obj,AttrObj.AttributeDefName)
    End If
  Else
    Obj.Attributes.Remove AttrObj
  End if
  Next
  'Добавление недостающих атрибутов
  For Each AttrDef in ObjDef.AttributeDefs
    If Obj.Attributes.Has(AttrDef.SysName) = False Then
      Obj.Attributes.Create AttrDef
      CountAdd = CountAdd + 1
      Call AttrFill(Obj,AttrDef.SysName)
    End If
  Next
End Sub

'Процедура заполнения значения обязательных атрибутов
Sub AttrFill(Obj,AttrName)
  If ThisApplication.AttributeDefs.Has(AttrName) = False Then Exit Sub
  If Obj.Attributes.Has(AttrName) = False Then Exit Sub
  If Obj.ObjectDef.AttributeDefs.Has(AttrName) = False Then Exit Sub
  Set AttrDef = Obj.ObjectDef.AttributeDefs(AttrName)
  If AttrDef.Required = False Then Exit Sub
  Set Attr = Obj.Attributes(AttrName)
  If Attr.Empty = False Then Exit Sub
  
  Select Case AttrDef.Type
    Case 8, 6 'Классификатор
      If not AttrDef.Classifier is Nothing Then
        Set Clf = AttrDef.Classifier
        If Clf.Classifiers.Count <> 0 Then
          Attr.Classifier = Clf.Classifiers(0)
        End If
      End If
      
    Case 7 'Ссылка на объект
      If AttrDef.ObjectDefs.Count <> 0 Then
        If AttrDef.ObjectDefs(0).Objects.Count <> 0 Then
          Attr.Object = AttrDef.ObjectDefs(0).Objects(0)
        End If
      Else
        Attr.Object = Obj
      End If
      
    Case 9 'Ссылка на пользователя
      Attr.User = ThisApplication.CurrentUser
      
    Case 11 'Таблица
      Attr.Rows.Create
      
    Case Else
      On Error Resume Next
      Val = Int ((-32767- 32766 + 1) * Rnd - 32767)
      Obj.Attributes(AttrName).Value = Val
      Do While Obj.Attributes(AttrName).Empty = True
        Val = Int ((-32767- 32766 + 1) * Rnd - 32767)
        Obj.Attributes(AttrName).Value = Val
        If Obj.Attributes(AttrName).Empty = True Then
          sVal = Cstr(Val)
          Obj.Attributes(AttrName).Value = sVal
        End If
        If Obj.Attributes(AttrName).Value = Val Then Exit Do
      Loop
      Err.Clear
      On Error GoTo 0
  End Select
End Sub



