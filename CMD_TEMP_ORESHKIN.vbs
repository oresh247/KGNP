
'Set os = ThisApplication.Shell.SelObjects

'For Each o In os
'  ThisApplication.ExecuteScript "OBJECT_KD_BASE_DOC", "SetIcon", o
'Next



'Set s = ThisApplication.Statuses("Договор заключен")
'msgbox s.SysName

''USE CMD_FSO
''USE CMD_MESSAGE

''Call LoadMessage()

'''Call CreateTextFile("ghbvth", "c:\temp\111.txt")

'''Call WriteEvent()

'''Call SetRoutToObject()

'''Call SetVersionElaros("5.0")


''Sub SetRoutToObject()
''  sRouteStr = ThisApplication.Commands("ROUTE_SPDS").Script
''  Set oRoadmap = ThisApplication.GetObjectByGUID("{505C40E4-C8B6-40D0-8AAB-B5C6C97BB71B}")
''  oRoadmap.Attributes("ATTR_ROADMAP_ROUTE").Value= sRouteStr
''End Sub


''Sub LoadMessage()
''  Set o = ThisApplication.GetObjectByGUID("{505C40E4-C8B6-40D0-8AAB-B5C6C97BB71B}")
''  Set rows = o.Attributes("ATTR_MESSAGES_TABLE").Rows
''  For i=1 to 299
''    sMessage = GetMessage_old(i)
''    If sMessage <> "" Then
''      Set row = rows.Create
''      row.Attributes("ATTR_MESSAGE_CODE")=i
''      row.Attributes("ATTR_MESSAGE_TYPE")=ThisApplication.Classifiers.Find("NODE_MESSAGE_NOTSET")
''      row.Attributes("Текст сообщения")=sMessage
''    End If
''  Next
''End Sub

'''Sub SetVersionElaros(ver)
'''  ThisApplication.ApplicationName = "ЭЛАРОС версия " ThisApplication.Attributes("ATTR_SYSTEM_VER") 
'''End Sub


''Sub WriteEvent()
''  ThisApplication.ExecuteScript "CMD_MESSAGE", "WriteToNotify", 173
''End Sub

''Sub CreateTextFile(str_,fname_)
''  Set f = CreateTextFileFromStr(str_,fname_)
''End Sub
