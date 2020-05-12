function readOmni, file
    compile_opt idl2, logical_predicate
    on_error, 2

    var = "Pressure"

    id = cdf_open(file, /readOnly)

    catch, error
    if error then begin
        catch, /cancel
        cdf_close, id
        message, /reissue_last
    endif

    cdf_control, id, variable=var, get_var_info=info
    cdf_attget, id, "FILLVAL", var, badVal

    cdf_varget, id, var, data, rec_count=info.maxRec+1

    catch, /cancel
    cdf_close, id

    data = reform(data, /overwrite)

    data[where(data eq badVal)] = !values.f_NaN

    return, data

end