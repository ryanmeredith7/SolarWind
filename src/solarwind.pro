pro SolarWind, results
    compile_opt idl2, logical_predicate

    results = boolarr(12, 26)

    for i = 0, 25 do begin
        for j = 0, 11 do begin
            file = findOmni(1995 + i, 1 + j)
            if file eq "" then continue
            results[j,i] = testOmni(readOmni(file))
        endfor
    endfor

    print, timegen(12, units="Months"), format='(4X, 12C(X, CMoA3))'
    for i = 0, 25 do print, 1995 + i, results[*,i], format='(13I4)'

end

compile_opt idl2, logical_predicate

SolarWind, results

end