use CMD_KD_GLOBAL_VAR_LIB 

Sub Query_BeforeExecute(Query, Obj, Cancel)
    hndl = GetGlobalVarrible("templ")
    if hndl = "" then 
      cancel = true
    else
      query.Parameter("PARAM0") = hndl
    end if
End Sub

