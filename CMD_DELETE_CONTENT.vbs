' Автор: Стромков С.А.
'
' Удаляет состав объекта
'------------------------------------------------------------------------------------------------------
' Авторское право © ЗАО «СиСофт», 2016

Dim o,p
set o=ThisObject
o.Permissions = SysAdminPermissions
set p=o.Parent

Call Main(o)

Sub Main (o_)
  For Each oObj In o_.ContentAll
    'oObj.Permissions = SysAdminPermissions
    oObj.Erase
  Next
End Sub


