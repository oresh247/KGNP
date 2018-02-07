' Команда - Передать на согласование (Документ закупки)
'------------------------------------------------------------------------------
' Автор: Чернышов Д.С.
' Авторское право © АО «СИСОФТ», 2017 г.

Call Main(ThisObject)

Sub Main(Obj)
  ThisScript.SysAdminModeOn
  
  'Маршрут
  'StatusName = "STATUS_DOC_IS_MATCHING"
  StatusName = "STATUS_KD_AGREEMENT"
  
  RetVal = ThisApplication.ExecuteScript("CMD_ROUTER", "Run",Obj,Obj.Status,Obj,StatusName)
  If RetVal = -1 Then
    Obj.Status = ThisApplication.Statuses(StatusName)
  End If
  
  ThisScript.SysAdminModeOff
End Sub
