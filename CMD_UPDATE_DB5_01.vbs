
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
    "Обновление базы от 10.01.2018")
  If ans<>vbYes Then Exit Sub
  
  Call Run()
  msgbox "Обновление базы завершено!",vbInformation,"Завершение"
End Sub

Sub Run()

'================================= Новое обновление БД-4
Call AddGroups()
progress.Position = 30
Call SetStageRole()
progress.Position = 60

progress.Position = 100
'===================================================  

End Sub

Sub AddGroups()
  Set gr = AddGroup("GROUP_PLANNING_ECONOMISTS")
  gr.SysName = "GROUP_PLANNING_ECONOMISTS"
  gr.Description = "Планово-экономическая группа"
'  Set u = ThisApplication.Users.GetUserByLogin("Скрипальщикова")
'  If gr.Users.Has(u) = False Then
'    gr.Users.Add ThisApplication.Users.GetUserByLogin("Скрипальщикова")
'  End If
End Sub

Sub SetStageRole()
  For each Obj In ThisApplication.ObjectDefs("OBJECT_CONTRACT_STAGE").Objects
    If Obj.Roles.Has("ROLE_FULLACCESS") = False Then
      Call ThisApplication.ExecuteScript("CMD_DLL", "SetRole",Obj,"ROLE_FULLACCESS",ThisApplication.Groups("GROUP_PLANNING_ECONOMISTS"))
    End If
  Next
End Sub
