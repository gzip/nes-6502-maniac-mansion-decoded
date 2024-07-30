@ECHO OFF
SETLOCAL
SET BUILD_DIR=%~DP0
SET VERSION=1_6
SET BASE_ROM=Maniac Mansion (USA)
SET MM_ROM="%BASE_ROM%.nes"
SET OUT_NAME=%BASE_ROM% Decoded
SET OUT_ROM="%OUT_NAME%.nes"
SET PATCH_NAME="%OUT_NAME% Base v%VERSION%.bps"
SET PATCH_PUZZLE_NAME="%OUT_NAME% with Puzzle v%VERSION%.bps"
SET PATCH_FULL_NAME="%OUT_NAME% with Optionals v%VERSION%.bps"
SET PACKAGE_NAME="%OUT_NAME% v%VERSION%.zip"
SET SNARFBLASM=%BUILD_DIR%tools\snarfblasm
SET FLIPS=tools\flips
SET DD=tools\dd

CD "%BUILD_DIR%"

IF "%1" == "clean" (
  ECHO Cleaning up generated files...
  DEL src\*.ips 2>NUL
  DEL src\puzzle\model_room.ips 2>NUL
  DEL src\puzzle\chainsaw.ips 2>NUL
  DEL src\puzzle\stairs.ips 2>NUL
  DEL %PATCH_NAME% 2>NUL
  DEL %PATCH_PUZZLE_NAME% 2>NUL
  DEL %PATCH_FULL_NAME% 2>NUL
  DEL %OUT_ROM% 2>NUL
  DEL %PACKAGE_NAME% 2>NUL
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

ECHO Building decoded patches...
CD src
%SNARFBLASM% clear_data.asm
%SNARFBLASM% clear_banks.asm
%SNARFBLASM% decompress.asm
%SNARFBLASM% decompressed_tiles.asm
%SNARFBLASM% layout_metadata.asm
%SNARFBLASM% decompressed_layouts.asm
%SNARFBLASM% decompressed_title_screens.asm
%SNARFBLASM% remap_table.asm
%SNARFBLASM% title_sprites.asm
CD ..

ECHO Patching in decoded changes...
%FLIPS% src\clear_data.ips %MM_ROM%
%FLIPS% src\decompress.ips %MM_ROM%
%FLIPS% src\remap_table.ips %MM_ROM%
%FLIPS% src\layout_metadata.ips %MM_ROM%
%FLIPS% src\decompressed_layouts.ips %MM_ROM%
%FLIPS% src\patches\maniac_mousedriver.ips %MM_ROM%
%FLIPS% src\patches\hide_keypad.ips %MM_ROM%
%FLIPS% src\patches\hide_pennant.ips %MM_ROM%

ECHO Expanding rom...
%DD% if=%MM_ROM% of=%OUT_ROM%
%DD% if=%MM_ROM% bs=16 skip=1 of=%OUT_ROM% seek=16385

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  git checkout %MM_ROM%
)

ECHO Clearing banks...
%FLIPS% src\clear_banks.ips %OUT_ROM%

ECHO Patching in decompressed tiles and layouts...
%FLIPS% src\decompressed_tiles.ips %OUT_ROM%
%FLIPS% src\decompressed_title_screens.ips %OUT_ROM%

ECHO Patching in various fixes...
%FLIPS% src\title_sprites.ips %OUT_ROM%
%FLIPS% src\patches\under_house.ips %OUT_ROM%
%FLIPS% src\patches\coin_box.ips %OUT_ROM%
%FLIPS% src\patches\fence_mask.ips %OUT_ROM%
%FLIPS% src\patches\gargoyle_palette.ips %OUT_ROM%
%FLIPS% src\patches\meteor_color.ips %OUT_ROM%
%FLIPS% src\patches\michael_select_palette.ips %OUT_ROM%
%FLIPS% src\patches\developer.ips %OUT_ROM%
%FLIPS% src\patches\radioactive_slime.ips %OUT_ROM%

ECHO Building base patch...
%FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_NAME%

IF "%1" NEQ "base" (
  ECHO Building optional patches...
  CD src\patches\optional
  %SNARFBLASM% portraits.asm
  %SNARFBLASM% title_screen.asm
  %SNARFBLASM% char_select.asm
  CD "%BUILD_DIR%"

  ECHO Patching in optionals...
  %FLIPS% src\patches\optional\fridge.ips %OUT_ROM%
  %FLIPS% src\patches\optional\portraits.ips %OUT_ROM%
  %FLIPS% src\patches\optional\char_select.ips %OUT_ROM%
  %FLIPS% src\patches\optional\under_house_enhanced.ips %OUT_ROM%

  IF "%1" == "title" (
    %FLIPS% src\patches\optional\title_screen.ips %OUT_ROM%
  )

  ECHO Building patch with optionals...
  %FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_FULL_NAME%
) ELSE (
  SET PATCH_FULL_NAME=
)

IF "%1" == "puzzle" (
  ECHO Building puzzle patches...
  CD src\puzzle
  %SNARFBLASM% model_room.asm
  %SNARFBLASM% chainsaw.asm
  %SNARFBLASM% stairs.asm
  CD "%BUILD_DIR%"

  ECHO Building patch with puzzle...
  %FLIPS% src\puzzle\puzzle_base.ips %OUT_ROM%
  %FLIPS% src\puzzle\model_room.ips %OUT_ROM%
  %FLIPS% src\puzzle\chainsaw.ips %OUT_ROM%
  %FLIPS% src\puzzle\stairs.ips %OUT_ROM%

  %FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_PUZZLE_NAME%
) ELSE (
  SET PATCH_PUZZLE_NAME=
)

IF "%1" == "release" GOTO release
IF "%2" == "release" GOTO release
GOTO endrelease
:release
  WHERE /Q tar
  IF NOT ERRORLEVEL 1 (
    tar -c -a -f %PACKAGE_NAME% README.txt %PATCH_PUZZLE_NAME% %PATCH_FULL_NAME% %PATCH_NAME% -C src/patches optional/*.ips
    WHERE /Q zipinfo
    IF NOT ERRORLEVEL 1 (
      zipinfo %PACKAGE_NAME%
    )
  ) ELSE (
    ECHO The tar program was not found, unable to build a release package!
  )
:endrelease
