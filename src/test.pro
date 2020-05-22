function func, m
    compile_opt idl2, logical_predicate

    common globals, x, n, f, d1f, d2f

    sum = 0.0

    for i = 0, n-1 do sum += total(f(x[i] - m, m[i] - m, x[i] - x, i - [0:n-1]), /NaN)

    return, sum

end

function grad, m
    compile_opt idl2, logical_predicate

    common globals

    g = fltarr(n, /noZero)

    for i = 0, n-1 do begin
        d1 = x[i] - m
        d2 = m[i] - m
        d3 = x[i] - x
        d4 = i - [0:n-1]
        g[i] = total(d2f(d1, d2, d3, d4) - d1f(-d1, -d2, -d3, -d4) - d2f(-d1, -d2, -d3, -d4), /NaN)
    endfor

    return, g

end

compile_opt idl2, logical_predicate

common globals

file = findOmni(2000, 11)
data = readOmni(file)

x = data
n = n_elements(data)

f = lambda("d1, d2, d3, d4: d1*d1/2.0*float(d4 eq 0.0) + 1e15*abs(d2)")
d1f = lambda("d1, d2, d3, d4: d1*(d4 = 0)")
d2f = lambda("d1, d2, d3, d4: 1e15*signum(d2)")

dfpmin, data, 1e-6, fmin, "func", "grad"

end
