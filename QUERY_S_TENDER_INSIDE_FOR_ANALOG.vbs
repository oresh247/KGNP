

Sub Query_AfterExecute(Sheet, Query, Obj)
  RowsCount = Sheet.RowsCount
  If RowsCount > 0 Then
    j = 0
    For i = RowsCount-1 to 0 Step -1
      If i > RowsCount-1-j Then Exit For
      Set Child = Sheet.RowValue(i)
      If not Child is Nothing Then
        If Child.ObjectDefName <> "OBJECT_TENDER_INSIDE" Then
          Sheet.RemoveRow i
          j = j + 1
        End If
      End If
    Next
  End If
End Sub