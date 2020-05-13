function testOmni, data
    compile_opt idl2, logical_predicate

    der = deriv(data)

    big = max(der)

    return, boolean(big ge 3)

end
