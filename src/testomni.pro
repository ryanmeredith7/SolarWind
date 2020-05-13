function testOmni, data
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

    ;Checks if the derivative is bigger than 3 anywhere.
    return, boolean(big ge 3)

end