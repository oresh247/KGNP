

Sub Form_BeforeShow(Form, Obj)
  thisScript.SysAdminModeOn
  form.Description = form.Controls("STATIC1").Value
End Sub