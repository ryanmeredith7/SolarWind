function pwc, m
    compile_opt idl2, logical_predicate

    common globals, x, n, func

    sum = 0.0

    for i = 0, n-1 do sum += total(func(x[i] - m, m[i] - m, x[i] - x, i - [0:n-1]), /NaN)

    return, sum

end

compile_opt idl2, logical_predicate

common globals

file = findOmni(2000, 11)
data = readOmni(file)

x = data
n = n_elements(data)

func = lambda("d1, d2, d3, d4: d1*d1/2.0*float(d4 eq 0.0) + 1e15*abs(d2)")

;powell, 

end
