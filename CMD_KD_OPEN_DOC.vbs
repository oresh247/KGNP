
  Set CreateObjDlg = ThisApplication.Dialogs.EditObjectDlg 
  set doc = thisObject.Attributes("ATTR_KD_DOCBASE").Object
  if not doc is nothing then 
    CreateObjDlg.Object = thisObject.Attributes("ATTR_KD_DOCBASE").Object
   ' CreateObjDlg.ActiveForm = order.ObjectDef.InputForms(1)
    ans = CreateObjDlg.Show
  end if
