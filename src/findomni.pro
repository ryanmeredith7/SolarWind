function findOmni, date
    compile_opt idl2, logical_predicate
    on_error, 2
    ;+
    ;This function finds previously downloaded CDF files containing omni data.
    ;
    ;Arguments:
    ;   date: Julian day of desired data.
    ;
    ;Return Value:
    ;   String containing path to file if it exists,
    ;   or empty string if it doesn't.
    ;-

    caldat, date, month, !null, year

    ;Checks if year and month are valid.
    if year lt 1995 then message, "No omni data from before 1995."

    ;Finds the base folder for the project.
    baseDir = routine_dir()
    if file_basename(baseDir) eq "src" then baseDir = file_dirname(baseDir)

    ;Creates the path where the file should be.
    file = filepath( $
        string(year, month, format="%4I-%02I.cdf"), $
        subdirectory = ["data","omni"], $
        root_dir = baseDir )

    ;Checks if the file exists.
    exists = file_test(file)

    return, exists ? file : ""

end
