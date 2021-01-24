function test2, inData
    compile_opt idl2, logical_predicate

    regConst = 120.0

    buffer = 100

    n = n_elements(inData)

    avg = total(inData, /NaN) / total(finite(inData), /integer)

    loss = total((inData - avg)^2, /NaN)

    partitions = objarr(buffer + 1)

    partitions[0] = obj_new('partition', inData, 0, n - 1, avg, loss)

    lossDiff = loss - total(partitions[0].losses)

    splitInd = 0

    k = 0

    catch, error
    if error then $
        if k-- gt buffer then begin
            message, /informational, "No more room in buffer, making it bigger"
            partitions = [temporary(partitions), objarr(buffer)]
        endif else begin
            catch, /cancel
            message, /reissue_last
        endelse

    while lossDiff gt regConst do begin

        partitions[[splitInd,++k]] = partitons[splitInd].split(inData)

        lossDiff = max(partitions[0:k].diff, splitInd)

    endwhile

    return, partitions[sort(partitions[0:k].start)]

end
