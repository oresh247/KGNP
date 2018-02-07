use "CMD_MARK_LIB"

'=============================================
Sub Form_BeforeShow(Form, Obj)
  'Дбавляем блокировку всех полей, если метка открыта не из верхней выборки меток на форме
  Set Dict2 = ThisApplication.Dictionary("MARK2") 
  Set Dict = ThisApplication.Dictionary("MARK") 
  
  if not dict.exists("NEWMARK") then 
  
        if dict2.exists("MARKCOR") then 
                If  dict2.Item("MARKCOR")<>1 then
                    ThisForm.Controls("ATTR_MARK_NAME").Enabled = false
                    ThisForm.Controls("ATTR_MARK_TYPE").Enabled = false
                else
                end if
        else
        ThisForm.Controls("ATTR_MARK_NAME").Enabled = false
        ThisForm.Controls("ATTR_MARK_TYPE").Enabled = false
        end if        
end if

End Sub
'=============================================
Sub ATTR_MARK_NAME_Modified()
  Str = ThisObject.Attributes("ATTR_MARK_NAME").Value
  call ReplaceStr(Str)
  ThisObject.Attributes("ATTR_MARK_NAME").Value = Str
End Sub
