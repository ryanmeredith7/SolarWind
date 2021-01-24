function getTEC, loc, date
    compile_opt idl2, logical_predicate

    daysPassed = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334]

    caldat, date, month, day, year, hour

    if year lt 2013 then message, "No TEC data from before 2013."

    if year mod 4 eq 0 then daysPassed[2:*] += 1
    day += daysPassed[month - 1]

    ftpDir = string(year, day, hour, format="gps/ismr/%4I/%03I/%02I/")

    letter = (hour + 97).toASCII()
    year -= year lt 2000 ? 1900 : 2000

    file = string(loc.toLower(), year, day, letter, format="%3Sc%02I%03I%1S.ismr.gz")

    baseDir = routine_dir()
    if file_basename(baseDir) eq "src" then baseDir = file_dirname(baseDir)

    localDir = filepath("ismr", subdirectory="data", root_dir=baseDir)
    if ~file_test(localDir, /directory) then file_mkdir, localDir

end
