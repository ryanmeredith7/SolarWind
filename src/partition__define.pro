function partition::init, data, a, b, level, loss
    compile_opt idl2, logical_predicate

    self.start = a
    self.finish = b
    self.level = level
    self.loss = loss

    if b - a gt 1 then begin

        x1 = data[a:b-1]
        x2 = rotate(data[a+1:b], 5)

        m1 = total(x1, /NaN, /cumulative) / total(float(finite(x1)), /cumulative)
        m2 = total(x2, /NaN, /cumulative) / total(float(finite(x2)), /cumulative)
        m2 = rotate(temporary(m2), 5)

        s = fltarr(2, b - a - 1, /noZero)
        for i = 0, b - a - 2 do begin
            s[0,i] = total((x1[0:i] - m1[i])^2, /NaN)
            s[1,i] = total((x2[0:-1-i] - m2[i])^2, /NaN)
        endfor

        self.diff = min(total(s, 1), i, /NaN)
        self.split = a + i + 1
        self.levels = [m1[i], m2[i]]
        self.losses = s[*,i]

    endif else begin

        self.split = b
        self.diff = loss
        self.levels = [data[a], data[b]]
        self.losses = [0.0, 0.0]

    endelse

    return, !true

end

function partition::split, data
    compile_opt idl2, logical_predicate

    out = objarr(2)

    out[0] = obj_new('partition', data, self.start, self.split - 1, self.levels[0], self.losses[0])
    out[1] = obj_new('partition', data, self.split, self.finish, self.levels[1], self.losses[1])

    obj_destroy, self

    return, out

end

pro partition__define
    compile_opt idl2, logical_predicate

    define = { partition $
        , start: 0 $
        , finish: 0 $
        , level: 0.0 $
        , loss: 0.0 $
        , split: 0 $
        , diff: 0.0 $
        , levels: fltarr(2) $
        , losses: fltarr(2) $
        }

end
