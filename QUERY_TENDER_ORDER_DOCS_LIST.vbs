

Sub Query_BeforeExecute(Query, Obj, Cancel)
If IsEmpty(Obj) = True or IsEmpty(Query) = True Then exit Sub
If Obj is Nothing Then exit Sub
  Set Dict = ThisApplication.Dictionary(Obj.GUID)
  ItemName = ThisApplication.CurrentUser.SysName
  
  If Dict.Exists(ItemName) Then
     Query.Parameter("GUID") = "= " & Dict.Item(ItemName)
    'ThisApplication.AddNotify Dict.Item(ItemName)
  End If
End Sub
