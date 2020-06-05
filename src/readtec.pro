function readTEC, file, ismrTemplate
    compile_opt idl2, logical_predicate

    tmpFile = filepath(file_basename(file) + ".tmp", /tmp)

    openr, inLun, file, /get_lun, /compress
    openw, outLun, tmpFile, /get_lun

    catch, error
    if error then begin
        catch, /cancel
        free_lun, inLun, /force
        free_lun, outLun, /force
        message, /reissue_last
    endif

    copy_lun, inLun, outLun

    catch, /cancel
    free_lun, inLun
    free_lun, outLun

    raw = read_ascii(tmpFile, template=ismrTemplate)
    file_delete, tmpFile

    data = ptrarr(32)

    for i = 0, 31 do begin

        ind = where(raw.prn eq i + 1, n)

        if n eq 0 then continue

        t = raw.tow[ind]

        ts = transpose([[t - 45], [t - 30], [t - 15], [t]])
        
        y = reform([[ts], [raw.tec[0:6:2,ind]], [raw.tec[1:7:2,ind]]], n * 4, 3)

        data[i] = ptr_new(y, /no_copy)

    endfor

    return, data

end
