' Автор: Стромков С.А.
'
' Удаляет объект со всем его составом
'------------------------------------------------------------------------------------------------------
' Авторское право © ЗАО «СиСофт», 2016 г.


Dim o
Set o = ThisObject
Call Main(o)

Sub Main(o_)
  Dim u
  ' Выбор пользователя
  Set u = ThisApplication.ExecuteScript("CMD_DIALOGS","SelectUsersDlg")
  If u Is Nothing Then Exit Sub
  ' Назначение на роль
  Call ThisApplication.ExecuteScript("CMD_DLL","SetRole",o_,"ROLE_CO_AUTHOR",u.SysName)
End Sub
