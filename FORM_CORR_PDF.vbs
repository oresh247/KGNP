

Sub Form_BeforeShow(Form, Obj)
' EV добавила для просмотра не только главного файла
  Set dict = ThisApplication.Dictionary("Files")
  If dict.Exists("FileName") Then 
      thisform.Controls("PREVIEW1").Value = dict.Item("FileName")
      thisform.Caption = " Просмотр файла " & dict.Item("FileName") & "."
      dict.RemoveAll
  end if
End Sub

