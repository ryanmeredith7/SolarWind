function readOmni, file
    compile_opt idl2, logical_predicate
    on_error, 2
    ;+
    ;This function reads omni data from CDF files from NASA's CDAWeb service.
    ;
    ;Arguments:
    ;   file: String with  a path to a CDF file with omni data.
    ;
    ;Return value:
    ;   Array of data read from the CDF file.
    ;-

    ;Sets the variable to be read. Could be changed to an argument later.
    var = "Pressure"

    ;Opens the CDF file.
    id = cdf_open(file, /readOnly)

    ;Error handler, closes the file and rethrows the error.
    catch, error
    if error then begin
        catch, /cancel
        cdf_close, id
        message, /reissue_last
    endif

    ;Get information about the variable to be read.
    cdf_control, id, variable=var, get_var_info=info
    cdf_attget, id, "FILLVAL", var, badVal

    ;Reads in the data.
    cdf_varget, id, var, data, rec_count=info.maxRec+1

    ;Cancels the error handler and closes the file.
    catch, /cancel
    cdf_close, id

    ;Changes the data to be 1 dimensional.
    data = reform(data, /overwrite)

    ;Replaces bad values with NaN.
    data[where(data eq badVal)] = !values.f_NaN

    return, data

end