
USE "CMD_DLL_UPDATE"
'===========================================================================================================


  ThisScript.SysAdminModeOn
  ThisApplication.Utility.WaitCursor = True
  Set Progress = ThisApplication.Dialogs.ProgressDlg
  Progress.Start
  progress.SetLocalRanges 0,100
  progress.Position = 0
  
  Call Update()
  
  progress.Position = 100
  ThisApplication.Utility.WaitCursor = False
  Progress.Stop
  
  
Sub Update()
  ans = msgbox ("Процедура обновления может занять некоторое время. Продолжить? ",vbQuestion+vbYesNo,_
    "Обновление базы от 15.12.2017")
  If ans<>vbYes Then Exit Sub
  
  Call Run()
  msgbox "Обновление базы завершено!",vbInformation,"Завершение"
End Sub

Sub Run()

'================================= Новое обновление БД-4

Call SetSystemAttrs("")
  progress.Position = 70
Call misc()
Call DeleteClassifiers()
'===================================================  

End Sub

' Установка системных атрибутов
Sub SetSystemAttrs(aList)
  Progress.Text = "Настройка системных атрибутов"
  lst = "ATTR_AGREENENT_SETTINGS," & aList
  arr = Split(lst,",")
  
  For each attrname In arr
    Progress.Text = "Настройка системных атрибутов: " & attrname
    Select Case attrname
      Case "ATTR_AGREENENT_SETTINGS"
        Call Set_ATTR_AGREENENT_SETTINGS()
    End Select
  Next
End Sub

Sub Set_ATTR_AGREENENT_SETTINGS()
 ' Заполняем функцию в таблицу согласования
  Set Table = ThisApplication.Attributes("ATTR_AGREENENT_SETTINGS")
    For each row in Table.Rows
      Select Case row.Attributes("ATTR_KD_OBJ_TYPE").Value
        Case "OBJECT_AGREEMENT"
          row.attributes("ATTR_KD_FINISH_STATUS").value = "STATUS_AGREEMENT_FOR_SIGNING"
          
        Case "OBJECT_CONTRACT"
          row.attributes("ATTR_KD_FINISH_STATUS").value = "STATUS_CONTRACT_FOR_SIGNING"
      End Select
    Next
End Sub

Sub misc()
  Call RemoveRoleFromCommand("CMD_CONTRACT_STAGE_CREATE","ROLE_APPROVER")
  Call RemoveRoleFromCommand("CMD_DOC_INVALIDATED","ROLE_DOC_DEVELOPER")
  Call RemoveRoleFromCommand("CMD_DOC_INVALIDATED","ROLE_LEAD_DEVELOPER")
  Call RemoveRoleFromCommand("CMD_VOLUME_PASS_NK","ROLE_VOLUME_PASS_NK")
  Call RemoveRoleFromCommand("CMD_WORK_DOCS_SET_PASS_NK","ROLE_WORK_DOCS_SET_PASS_NK")
End Sub

Sub DeleteClassifiers()
  List = "NODE_B5AAE1D9_18FC_4755_BE91_3D6A48350C0C,NODE_9DEEF912_2142_4BB0_B4F6_96B4F9D96D4D,NODE_5C6FBFA6_B6E8_403B_8AE5_879F327AA2A1"
  Call SystemObjDelByList(List)
End Sub
