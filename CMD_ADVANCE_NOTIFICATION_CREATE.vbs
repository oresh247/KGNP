' $Workfile: COMMAND.SCRIPT.CMD_ADVANCE_NOTIFICATION_CREATE.scr $ 
' $Date: 10.10.08 15:57 $ 
' $Revision: 3 $ 
' $Author: Oreshkin $ 
'
' Создать предварительное извещение
'------------------------------------------------------------------------------
' Авторское право © ЗАО «НАНОСОФТ», 2008 г.


Dim o
Set o = ThisObject
Call Main(o)

Sub Main(o_)
	Dim oNew
	' Создание извещения
	Set oNew =  ThisApplication.ObjectDefs("OBJECT_ADVANCE_NOTIFICATION").CreateObject
	oNew.Permissions = SysAdminPermissions 
	Call SetAttrs(o_,oNew)
	Set oNew = ShowDialog(oNew)
End Sub

Private Sub SetAttrs(p_,o_)
	o_.Attributes("ATTR_PROJECT") = p_
End Sub

Private Function ShowDialog(o_)
	Dim EditObjDlg
	Set ShowDialog = Nothing
	Set EditObjDlg = ThisApplication.Dialogs.EditObjectDlg
	o_.Permissions = SysAdminPermissions 
	EditObjDlg.object = o_
	EditObjDlg.ParentWindow = ThisApplication.hWnd
	If Not EditObjDlg.Show Then 
		o_.Erase 
	End If
	Set ShowDialog = o_
End Function