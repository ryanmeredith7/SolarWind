function getOmni, year, month ;test
    compile_opt idl2, logical_predicate
    on_error, 2

    if year lt 1995 then message, "No omni data from before 1995."
    if month lt 1 or month gt 12 then message, "Invalid month."

    localDir = routine_dir()
    if file_basename(localDir) eq "src" then localDir = file_dirname(localDir)
    localPath = filepath( $
        string(year, month, format="%4I-%02I.cdf"), $
        subdirectory = ["data","raw","omni"], $
        root_dir = localDir)

    ftpDir = "pub/data/omni/omni_cdaweb/hro2_1min/"
    ftpName = string(year, month, format="omni_hro2_1min_%4I%02I01_v01.cdf")
    ftpPath = string(ftpDir, year, ftpName, format="%S/%4I/%S")

    ftp = IDLnetURL( $
        url_scheme = "ftp", $
        url_hostname = "cdaweb.gsfc.nasa.gov", $
        url_path = ftpPath, $
        ftp_connection_mode = 0)

    catch, error
    if error then begin
        catch, /cancel
        ftp.getProperty, response_code=code
        obj_destroy, ftp
        case code of
            9: message, "No omni data for the given year."
            78: message, "No omni data for the given month."
            else: message, /reissue_last
        endcase
    endif

    file = ftp.get(filename=localPath, /ftp_explicit_ssl)

    catch, /cancel
    obj_destroy, ftp

    return, file

end
