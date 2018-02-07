' Автор: Стромков С.А.
'
' Создание разделов
'------------------------------------------------------------------------------------------------------
' Авторское право © ЗАО «СиСофт», 2016

Sub Form_BeforeShow(Form, Obj)
  form.Caption = form.Description
  set cCtl=Form.controls 
  ' Для системной папки блокируем наименование папки от изменения
  If Obj.Attributes.Has("ATTR_SYSTEM_FOLDER") Then _
    cCtl("ATTR_FOLDER_NAME").Readonly = Obj.Attributes("ATTR_SYSTEM_FOLDER").value
End Sub
