function test3, inData
    compile_opt idl2, logical_predicate

    regConst = 120.0

    buffer = 200

    n = n_elements(inData)

    level = total(inData, /NaN) / total(finite(inData), /integer)

    loss = total((inData - level)^2, /NaN)

    a = 0
    b = n - 1

    @mkpart

    lossDiff = loss - total(partition.losses)

    partitions = replicate(partition, buffer + 1)

    splitInd = 0

    k = 0
    
    catch, error
    if error then $
        if k-- gt buffer then begin
            message, /informational, "No more room in buffer, making it bigger"
            partitions = [temporary(partitions), replicate(partition, buffer)]
        endif else begin
            catch, /cancel
            message, /reissue_last
        endelse

    while lossDiff gt regConst do begin

        thisPart = partitions[splitInd]

        level = thisPart.levels[0]
        loss = thisPart.losses[0]
        a = thisPart.start
        b = thisPart.split - 1
        @mkpart
        partitions[splitInd] = partition

        level = thisPart.levels[1]
        loss = thisPart.losses[1]
        a = thisPart.split
        b = thisPart.finish
        @mkpart
        partitions[++k] = partition

        lossDiff = max(partitions[0:k].diff, splitInd)

    endwhile

    return, partitions[sort(partitions[0:k].start)]

end
