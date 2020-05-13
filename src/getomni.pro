function getOmni, year, month
    compile_opt idl2, logical_predicate
    on_error, 2
    ;+
    ;This function downloads omni data in CDF files off NASA's ftp server.
    ;
    ;Arguments:
    ;   year: Year of requested data as integer.
    ;   month: Month of requested data as integer.
    ;
    ;Return Value:
    ;   String containing the path to the downloaded file.
    ;-

    ;Makes sure year and month are in the proper range.
    if year lt 1995 then message, "No omni data from before 1995."
    if month lt 1 or month gt 12 then message, "Invalid month."

    ;Gets the base directory of the project.
    baseDir = routine_dir()
    if file_basename(baseDir) eq "src" then baseDir = file_dirname(baseDir)

    ;Gets the folder to put data in and makes it if it doesn't exist.
    localDir = filepath("omni", subdirectory=["data","raw"], root_dir=baseDir)
    if ~file_test(localDir, /directory) then file_mkdir, localDir

    ;Creates the place to put the data file.
    localName = string(year, month, format="%4I-%02I.cdf")
    localPath = filepath(localName, root_dir=localDir)

    ;Sets up the path of the file to be downloaded.
    ftpRootDir = "pub/data/omni/omni_cdaweb/hro2_1min/"
    ftpName = string(year, month, format="omni_hro2_1min_%4I%02I01_v01.cdf")
    ftpPath = string(ftpRootDir, year, ftpName, format="%S/%4I/%S")

    ;Creates an ftp object to do the download.
    ftp = IDLnetURL( $
        url_scheme = "ftp", $
        url_hostname = "cdaweb.gsfc.nasa.gov", $
        url_path = ftpPath, $
        ftp_connection_mode = 0 )

    ;Error handler, checks reason for error, then cleans up the ftp object.
    ;Depending on error, gives an informative error message, or rethrows.
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

    ;Downloads the file.
    file = ftp.get(filename=localPath, /ftp_explicit_ssl)

    ;Cancels the error handler and cleans up the ftp object.
    catch, /cancel
    obj_destroy, ftp

    return, file

end