function test, x
    compile_opt idl2, logical_predicate
    
    jumps = 200

    y = 120.0

    n = n_elements(x)

    m = mean(x, /NaN)

    r = [0, n, replicate(n+1, jumps)]

    l = [m, replicate(!values.f_NaN, jumps)]

    npos = total((x - m)^2, /NaN)

    s = [npos, replicate(!values.f_NaN, jumps)]

    pos = fltarr(n, /noZero)

    m = fltarr(2, n, /noZero)

    st = fltarr(2, n, /noZero)

    k = 0

    repeat begin

        replicate_inplace, pos, !values.f_NaN
        opos = temporary(npos)

        for j = 0, k do begin

            ri = r[j]
            rf = r[j+1]-1

            for i = ri+1, rf do begin

                x1 = x[ri:i-1]
                x2 = x[i:rf]

                m1 = mean(x1, /NaN)
                m2 = mean(x2, /NaN)

                st[0,i] = [total((x1 - m1)^2, /NaN), total((x2 - m2)^2, /NaN)]

                pos[i] = total(st[*,i], /NaN) + total(s, /NaN) - s[j]

                m[0,i] = [m1, m2]

            endfor

        endfor

        npos = min(pos, i, /NaN)
        print, k, opos - npos

        r[k+2] = i
        r[0] = r.sort(count=k+3)

        j = (where(r eq i))[0] - 1

        l[j] = j ge k ? m[*,i] : [m[*,i], l[j+1:k]]

        s[j] = j ge k ? st[*,i] : [st[*,i], s[j+1:k]]
        
        k += 1

    endrep until opos - npos le y

    out = fltarr(n, /noZero)

    for i = 0, k do out[r[i]:r[i+1]-1] = l[i]

    return, out

end
