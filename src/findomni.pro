function findOmni, year, month
    compile_opt idl2, logical_predicate
    
    if year lt 1995 then message, "No omni data from before 1995."
    if month lt 1 or month gt 12 then message, "Invalid month."
    
    baseDir = routine_dir()
    if file_basename(baseDir) eq "src" then baseDir = file_dirname(baseDir)
    
    file = filepath( $
        string(year, month, format="%4I-%02I.cdf"), $
        subdirectory = ["data","raw","omni"], $
        root_dir = baseDir )
    
    exists = file_test(file)
    
    return, exists ? file : ""
    
end