;reset idl session
.reset_session

print, routine_dir()

;compile project files
.compile 'src/solarwind.pro'

;resolve all routines
resolve_all, /continue_on_error

;create the project save file
save, /routines, filename='solarwind.sav', /verbose