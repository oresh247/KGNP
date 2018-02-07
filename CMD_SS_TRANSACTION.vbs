' textual including of this file intended

Class Transaction

  Public Sub Class_Initialize()
    If Not ThisApplication.IsActiveTransaction Then _
      ThisApplication.StartTransaction
  End Sub
  
  Public Sub Class_Terminate()
    If ThisApplication.IsActiveTransaction Then _
      ThisApplication.AbortTransaction
  End Sub
  
  Public Sub Commit()
    If ThisApplication.IsActiveTransaction Then _
      ThisApplication.CommitTransaction
  End Sub
End Class