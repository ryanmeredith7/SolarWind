if b - a gt 1 then begin

    x1 = inData[a:b-1]
    x2 = rotate(inData[a+1:b], 5)

    m1 = total(x1, /NaN, /cumulative) / total(float(finite(x1)), /cumulative)
    m2 = total(x2, /NaN, /cumulative) / total(float(finite(x2)), /cumulative)
    m2 = rotate(temporary(m2), 5)

    s = fltarr(2, b - a - 1, /noZero)

    for i = 0, b - a - 2 do begin
        s[0,i] = total((x1[0:i] - m1[i])^2, /NaN)
        s[1,i] = total((x2[0:-1-i] - m2[i])^2, /NaN)
    endfor

    diff = loss - min(total(s, 1), minInd, /NaN)

    partition = { partition $
        , start: a $
        , finish: b $
        , level: level $
        , loss: loss $
        , split: a + minInd + 1 $
        , diff: diff $
        , levels: [m1[minInd], m2[minInd]] $
        , losses: s[*,minInd] $
        }

endif else partition = { partition $
    , start: a $
    , finish: b $
    , level: level $
    , loss: loss $
    , split: b $
    , diff: loss $
    , levels: [inData[a], inData[b]] $
    , losses: [0.0, 0.0] $
    }
