

'Sub Query_AfterExecute(Sheet, Query, Obj)
'    ThisApplication.DebugPrint "BQUERY_NK_ISSUES1 "&time()
'    RCount = Sheet.RowsCount
'    thisApplication.DebugPrint Rcount
'    if Rcount <= 0 then  exit sub
''    if rCount = 1  then exit sub
'    Set oNKObj = ThisApplication.ExecuteScript("CMD_SS_LIB", "GetInspectionObject", Obj)
'    ThisApplication.DebugPrint "BQUERY_NK_ISSUES2 "&time()
'    set ico = oNKObj.ObjectDef.Icon
'    
'    if oNKObj is nothing then exit sub
''    bl = sheet.CellValue(0,1) 
'    For i=0 To RCount-1 
'      Sheet.RowIcon(i) = thisApplication.Icons("IMG_OK") 
'      ThisApplication.DebugPrint i&"BQUERY_NK_ISSUES3 "&time()
''      Set f = Sheet.RowFormat(i)
''      icoName = oNKObj.ObjectDef.Icon.SysName
''      select case Sheet.CellValue(i,"Исправлено")
''        case True  icoName = "IMG_OK"
''        case False f.Bold = TRUE 
''      end select  
''          if Sheet.RowIcon(i).SysName <> icoName then _
''                Sheet.RowIcon(i) = thisApplication.Icons(icoName) 
'    Next  
'End Sub

Sub Query_BeforeExecute(Query, Obj, Cancel)
  ThisApplication.DebugPrint "BQUERY_NK_ISSUES "&time()
End Sub