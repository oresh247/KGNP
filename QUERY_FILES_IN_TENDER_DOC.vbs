
Sub Query_AfterExecute(Sheet, Query, Obj)
  For i = 0 to Sheet.RowsCount-1
    newVal = Sheet.CellValue(i,"Размер, КБ")
    newval = round(cDbl(newval)/1024,1)
    Sheet.CellValue(i,"Размер, КБ") = newval
    if Sheet.CellValue(i,0) = "Скан документа" then Sheet.CellValue(i,0) = " Скан документа"
  next
  sheet.Sort 0
End Sub
