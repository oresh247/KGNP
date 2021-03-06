' $Workfile: COMMAND.SCRIPT.CMD_LIBRARY.scr $ 
' $Date: 29.09.08 12:37 $ 
' $Revision: 2 $ 
' $Author: Oreshkin $ 
'
' Библиотека функций
'------------------------------------------------------------------------------
' Авторское право © ЗАО «НАНОСОФТ», 2008 г.


Function SendMail(cUsers, cSubject, cObjects, mSystem, mBody, Editable)
  SendMail = True
  Set nMessage = ThisApplication.CreateMessage
  nMessage.To = cUsers
  nMessage.Subject = cSubject
  nMessage.System = mSystem
  nMessage.Body = mBody
  If Not cObjects Is Nothing Then
    Select Case TypeName(cObjects)
      Case "ITDMSObject"
        nMessage.Attachments.Add cObjects
      Case "ITDMSObjects"
        For Each tObj In cObjects
          nMessage.Attachments.Add tObj
        Next
    End Select
  End If
  If Editable Then
    Set mDialog = ThisApplication.Dialogs.EditMessageDlg
    mDialog.Message =  nMessage
    If mDialog.Show = False Then SendMail = False
  Else nMessage.Send
  End If
End Function
