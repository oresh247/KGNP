' Команда - Передать Документ на согласование
'------------------------------------------------------------------------------
' Автор: Чернышов Д.С.
' Авторское право © АО «СИСОФТ», 2017 г.

USE "CMD_PROJECT_DOCS_LIBRARY"

Call Run(ThisObject)

Sub Run(Obj)
  Set Dlg = ThisApplication.Dialogs.EditObjectDlg
  Dlg.Object = Obj
'  Dlg.ActiveForm = Obj.ObjectDef.InputForms("FORM_KD_DOC_AGREE")
  Dlg.Show
End Sub

