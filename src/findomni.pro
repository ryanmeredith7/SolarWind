function findOmni, year, month
    compile_opt idl2, logical_predicate
    on_error, 2
    ;+
    ;This function finds previously downloaded CDF files containing omni data.
    ;
    ;Arguments:
    ;   year: Year of requested data as integer.
    ;   month: Month of requested data as integer.
    ;
    ;Return Value:
    ;   String containing path to file if it exists,
    ;   or empty string if it doesn't.
    ;-

    ;Checks if year and month are valid.
    if year lt 1995 then message, "No omni data from before 1995."
    if month lt 1 or month gt 12 then message, "Invalid month."

    ;Finds the base folder for the project.
    baseDir = routine_dir()
    if file_basename(baseDir) eq "src" then baseDir = file_dirname(baseDir)

    ;Creates the path where the file should be.
    file = filepath( $
        string(year, month, format="%4I-%02I.cdf"), $
        subdirectory = ["data","raw","omni"], $
        root_dir = baseDir )

    ;Checks if the file exists.
    exists = file_test(file)

    return, exists ? file : ""

end