@ECHO OFF
SETLOCAL
SET BUILD_DIR=%~DP0
SET VERSION=1_0
SET MM_ROM="Maniac Mansion (USA).nes"
SET OUT_ROM="Maniac Mansion (USA) Relocated.nes"
SET PATCH_NAME="Maniac Mansion (USA) Relocated v%VERSION%.bps"
SET SNARFBLASM=%BUILD_DIR%tools\snarfblasm
SET FLIPS=tools\flips
SET DD=tools\dd

CD "%BUILD_DIR%"

IF "%1" == "clean" (
  ECHO Cleaning up generated files...
  DEL src\*.ips
  DEL %PATCH_NAME%
  DEL %OUT_ROM%
  EXIT /B
)

IF NOT EXIST %MM_ROM% (
  ECHO "Expected to find the following ROM (see build.bat to edit filename), exiting..."
  ECHO %MM_ROM%
  EXIT /B
)

IF "%1" == "patches" (
  WHERE /Q node
  IF NOT ERRORLEVEL 1 (
    node tools\generator\generator.js patches
  ) ELSE (
    ECHO Node executable not found, unable to generate the patches, exiting...
  )
  EXIT /B
)

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  ECHO Checking out clean roms...
  git checkout %MM_ROM%
)

ECHO Building patches...
CD src
%SNARFBLASM% relocated.asm
%SNARFBLASM% clear_banks.asm
CD ..

ECHO Patching...
%FLIPS% src\relocated.ips %MM_ROM%

%DD% if=%MM_ROM% of=%OUT_ROM%
%DD% if=%MM_ROM% bs=16 skip=1 of=%OUT_ROM% seek=16385

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  git checkout %MM_ROM%
)

ECHO Clearing banks...
%FLIPS% src\clear_banks.ips %OUT_ROM%

%FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_NAME%
