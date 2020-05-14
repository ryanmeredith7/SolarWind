pro SolarWind, results, quiet=quiet
    compile_opt idl2, logical_predicate

    results = boolarr(12, 25)

    for i = 0, 24 do begin
        for j = 0, 11 do begin
            file = findOmni(1995 + i, 1 + j)
            if file eq "" then file = getOmni(1995 + i, 1 + j)
            results[j,i] = testOmni(readOmni(file), 3)
        endfor
    endfor
    
    if ~keyword_set(quiet) then begin
        print, timegen(12, units="Months"), format='(5X, 12C(X, CMoA3))'
        for i = 0, 24 do print, 1995 + i, results[*,i], format='(13I4)'
    endif

end

compile_opt idl2, logical_predicate

SolarWind, results, /quiet

end
