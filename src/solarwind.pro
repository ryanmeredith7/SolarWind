pro SolarWind, data, results, quiet=quiet
    compile_opt idl2, logical_predicate

    data = ptrarr(12, 25)
    results = boolarr(12, 25)

    for i = 0, 24 do begin
        for j = 0, 11 do begin
            file = findOmni(1995 + i, 1 + j)
            if file eq "" then file = getOmni(1995 + i, 1 + j)
            data[j,i] = ptr_new(readOmni(file))
            results[j,i] = testOmni(*data[j,i], 6)
        endfor
    endfor
    
    if ~keyword_set(quiet) then begin
        print, "      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
        for i = 0, 24 do print, 1995 + i, results[*,i], format='(13I4)'
    endif

end

compile_opt idl2, logical_predicate

SolarWind, data, results, /quiet

end
