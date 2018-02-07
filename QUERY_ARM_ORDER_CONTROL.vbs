

Sub Query_AfterExecute(Sheet, Query, Obj)
    RCount = Sheet.RowsCount
    For i=0 To RCount-1 
      sDate = sheet.CellValue(i, "Плановый срок исполнения")
      if  isDate(sdate) then 
        dDate = CDate(sDate)
        if dDate < Date then 
            Set f = Sheet.RowFormat(i)
            f.Bold = TRUE 
            f.Color = RGB(255,0, 0)
        end if  
      end if  
      if sheet.CellValue(i, "Статус") = "Выдано" then 
          Set f = Sheet.RowFormat(i)
          f.Bold = TRUE 
      end if  

    Next  
End Sub