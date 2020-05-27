function test2, inData
    compile_opt idl2, logical_predicate

    regConst = 120.0

    buffer = 100

    n = n_elements(inData)

    jumps = lonarr(buffer + 2, /noZero)
    jumps[0] = 0
    jumps[1] = n

    levels = fltarr(buffer + 1, /noZero)

    losses = fltarr(buffer + 1, /noZero)
    lossPos = lonarr(buffer + 1, /noZero)

    lossFun = lambda("x, y: (x - y) ^ 2")
    print, "Created ", lossFun

    k = 0

    repeat begin

        if k eq 0 then begin

            avg = total(inData, /NaN) / total(finite(inData), /integer)
            levels[0] = avg

            newLoss = total((inData - temporary(avg))^2, /NaN)
            losses[0] = newLoss
            losspos[0] = 0

            as = 0
            bs = n - 1

        endif

        foreach a, as, i do begin

            b = bs[i]

            x1 = inData[a:b-1]
            x2 = rotate(inData[a+1:b], 5)

            m1 = total(x1, /NaN, /cumulative) $
                / total(float(finite(x1)), /cumulative)
            m2 = total(x2, /NaN, /cumulative) $
                / total(float(finite(x2)), /cumulative)
            m2 = rotate(temporary(m2), 5)

            s = fltarr(b - a - 1, /noZero)
            for k = 0, b - a - 2 do $
                s[k] = total((x1[0:k] - m1[k])^2, /NaN) $
                + total((x2[0:-1-k] - m2[k])^2, /NaN)

        endforeach

    endrep until oldLoss - newLoss lt regConst

end
