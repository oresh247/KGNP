
Sub Query_AfterExecute(Sheet, Query, Obj)
  If Sheet.ColumnsCount > 5 Then
    Sheet.ColumnName(2) = "Вид договора"
    Sheet.ColumnName(5) = "Исполнитель"
  End If
End Sub