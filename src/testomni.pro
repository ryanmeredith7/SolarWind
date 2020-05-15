function testOmni, data, lim
    compile_opt idl2, logical_predicate
    on_error, 2
    ;+
    ;This function tests omni data for large solar wind activity.
    ;
    ;Arguments:
    ;   data: Array with omni data. Right now is made for Pressure data,
    ;   but could work with other data set, this needs to be tested.
    ;   Also, could be extended or changed to use other data sets.
    ;
    ;Return Value:
    ;   Boolean, true if there is a lot of activity, false otherwise.
    ;-

    ;Gets the derivative of the data.
    der = deriv(data)

    ;Gets the biggest value of the derivative.
    big = max(der)

    ;Checks if the derivative is bigger than lim anywhere.
    return, boolean(big gt lim)

end

compile_opt idl2, logical_predicate

data = ptrarr(12, 25, /allocate_heap)

for i = 0, 24 do begin
    for j = 0, 11 do begin
        file = findOmni(1995 + i, 1 + j)
        if file eq "" then file = getOmni(1995 + i, 1 + j)
        *data[j,i] = readOmni(file)
    endfor
endfor

lim = 3
ans = "Yes"
results = boolarr(12, 25)

repeat begin

    read, lim, prompt="Minimum pressure rise rate (in nPa/min): "

    for i = 0, 24 do $
        for j = 0, 11 do $
            results[j,i] = testOmni(*data[j,i], lim)

    print, "      Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec"
    for i = 0, 24 do print, 1995 + i, results[*,i], format='(13I4)'

    read, ans, prompt="Would you like to continue? "

endrep until ans.startsWith("n", /fold_case)

end
