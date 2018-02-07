

Sub Form_BeforeShow(Form, Obj)
  form.Caption = form.Description
End Sub

Sub BUTTON_ADD_OnClick()
    Set frmSetShelve = ThisApplication.InputForms("FORM_TENDER_CONCURENT_ADD")
    If frmSetShelve.Show  then 
      txt = trim(frmSetShelve.Attributes("ATTR_NAME").Value)
      comm = trim(frmSetShelve.Attributes("ATTR_INF").Value)
      if txt <> "" Then 
        call AddConcurent(txt,comm)
        thisObject.Update
      end if  
    end if  
End Sub

Sub AddConcurent(txt,comment)
  Set Obj = ThisObject
  obj.Permissions = SysAdminPermissions
  Set Table = Obj.Attributes("ATTR_TENDER_CONCURENT_LIST")
  set rows = Table.Rows
  Set NewRow = rows.Create 
  NewRow.Attributes("ATTR_NAME").Value = txt
  NewRow.Attributes("ATTR_INF").Value = comment
End Sub

Sub QUERY_TENDER_CONCURENT_LIST_DblClick(iItem, bCancelDefault)
  bCancelDefault = True
  Call EditConcurent(iItem)
End Sub

Sub EditConcurent(iItem)
  Set Obj = ThisObject
  obj.Permissions = SysAdminPermissions
  Set Table = Obj.Attributes("ATTR_TENDER_CONCURENT_LIST")
  set rows = Table.Rows
  Set row = Table.Rows(iItem)
  Set frmSetShelve = ThisApplication.InputForms("FORM_TENDER_CONCURENT_ADD")
  frmSetShelve.Attributes("ATTR_NAME") = row.Attributes("ATTR_NAME")
  frmSetShelve.Attributes("ATTR_INF") = row.Attributes("ATTR_INF")
    If frmSetShelve.Show  then 
      row.Attributes("ATTR_NAME") = trim(frmSetShelve.Attributes("ATTR_NAME").Value)
      row.Attributes("ATTR_INF") = trim(frmSetShelve.Attributes("ATTR_INF").Value)
      Obj.Update
    End If
End Sub

Sub BUTTON_DEL_OnClick()
  Set control = ThisForm.Controls("QUERY_TENDER_CONCURENT_LIST")
  iSel = control.ActiveX.SelectedItem
  If iSel < 0 Then 
     msgbox "Ничего не выбрано!"
     Exit Sub 
  end if  
  
  Arr = thisapplication.Utility.ArrayToVariant(control.SelectedItems)

  Answer = MsgBox( "Вы уверены, что хотите удалить " & Cstr(Ubound(arr)+1) _
         & " строк?" , vbQuestion + vbYesNo,"Удалить?")
  if Answer <> vbYes then exit sub

  for i = 0 to Ubound(arr)
     set aprRow =  control.value.RowValue(arr(i))
     if DellRow(ThisObject, aprRow) then count = count + 1
  next
  if count>0 then 
       msgbox "Удалено " & count & " строк"
  end if
End Sub

function DellRow(Obj,row)
  thisScript.SysAdminModeOn
  DellRow = false
  set rows = Obj.Attributes("ATTR_TENDER_CONCURENT_LIST").Rows
  set r = rows(row)

  Obj.Permissions = sysAdminPermissions
  r.Erase
  Obj.Update
  DellRow = true
end function


Sub QUERY_TENDER_CONCURENT_LIST_ContextMenu(iItem, x, y, bCancelDefault)
  bCancelDefault = True
End Sub