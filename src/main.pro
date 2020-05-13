compile_opt idl2, logical_predicate

results = boolarr(12, 25)

for i = 0, 24 do begin
    for j = 0, 11 do begin
        file = findOmni(1995 + i, 1 + j)
        if file eq "" then file = getOmni(1995 + i, 1 + j)
        results[j,i] = testOmni(readOmni(file))
    endfor
endfor

end