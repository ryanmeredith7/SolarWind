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

    while lossDiff gt regConst do begin

        print, k, lossDiff

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

        lossDiff = max(partitions[0:k].loss - total(partitions[0:k].losses, 1), splitInd)

    endwhile

    return, partitions[0:k]

end
