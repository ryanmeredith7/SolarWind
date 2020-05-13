;reset idl session
.reset_session

;compile project files
.compile 'src/solarwind.pro'
.compile 'src/findomni.pro'
.compile 'src/getomni.pro'
.compile 'src/readomni.pro'
.compile 'src/testomni.pro'

;resolve all routines
resolve_all, /continue_on_error

;create the project save file
save, /routines, filename='solarwind.sav', /verbose
