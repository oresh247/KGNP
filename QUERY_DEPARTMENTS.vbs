

Sub Query_AfterExecute(Sheet, Query, Obj)
  For i = 0 to sheet.RowsCount-1
    sheet(i,"Отдел") = sheet(i,"Отдел") & " (" & sheet(i,"Площадка") & ")"
  Next
End Sub
