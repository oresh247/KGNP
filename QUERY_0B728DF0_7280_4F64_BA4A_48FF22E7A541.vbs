


Sub Query_AfterExecute(Sheet, Query, Obj)
dim clsf, obbbCls, obbbCls2, fullPath, parentCl  , RCount ,arrObj
  RCount = Sheet.RowsCount
 
 For i=0 To RCount-1 
    
  
  Set  obbbCls =sheet.RowValue(i)
  set  orgObj = ThisApplication.GetObjectByGUID(obbbCls.guid)
    fullPath=orgObj.Description
   While orgObj.guid <>"{4E01EB03-F956-4D48-A221-1C3ADB8C1EA4}"
     set parentCl = orgObj.Parent
        if   parentCl.guid <>"{4E01EB03-F956-4D48-A221-1C3ADB8C1EA4}"     then
          fullPath= parentCl.Description & "\" &fullPath
        end if 
     set orgObj = parentCl
   Wend
   sheet.CellValue(i,1) = fullPath
 Next
 
 
End Sub