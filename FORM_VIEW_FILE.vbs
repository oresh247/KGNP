
Sub BTNPackUnLoad_OnClick()  
'    Set FSO = CreateObject("Scripting.FileSystemObject") 
    Set objShell = CreateObject("Shell.Application")

    Set objFolder = objShell.BrowseForFolder (0, "Выберите папку:", 0, 0)

    If objFolder Is Nothing Then exit sub
    
    set file = thisObject.Files.Main
    File.CheckOut ObjFolder.Self.Path & "\" & File.FileName 
        
    objShell.Explore(ObjFolder.Self.Path)
'    Set FSO = CreateObject("Scripting.FileSystemObject") 
    Set objShell = nothing
End Sub