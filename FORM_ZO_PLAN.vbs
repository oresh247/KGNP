
Sub Form_BeforeShow(Form, Obj)
  form.Caption = form.Description
  Call SetControlsReadOnly(Form)
  Form.Controls("ATTR_DOC_REF").visible = False
End Sub

Sub SetControlsReadOnly(Form)
  For each cCtrl In Form.controls
    cCtrl.Readonly = Form.Attributes("ATTR_DOC_REF").Empty = False
  Next
End Sub

