' $Workfile: COMMAND.SCRIPT.CMD_COMMENT_DELETE.scr $ 
' $Date: 10.10.08 15:57 $ 
' $Revision: 2 $ 
' $Author: Oreshkin $ 
'
' Команда "Удалить комментарий"
'------------------------------------------------------------------------------
' Авторское право © ЗАО «НАНОСОФТ», 2008 г.

Use "COMMENT_FUNCTION_LIBRARY"

Set tComment = ThisObject

If ThisApplication.ExecuteScript("CMD_MESSAGE", "ShowWarning", vbInformation + vbYesNo, 1017)= vbYes Then
  tComment.Permissions = SysAdminPermissions 
  tComment.Erase
End If
