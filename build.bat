@ECHO OFF
SETLOCAL
SET BUILD_DIR=%~DP0
SET MM_ROM="Maniac Mansion (USA).nes"
SET OUT_ROM="Maniac Mansion (USA) Decoded.nes"
SET PATCH_NAME="Maniac Mansion (USA) Decoded v1_2.bps"
SET PATCH_PUZZLE_NAME="Maniac Mansion (USA) Decoded with Puzzle v1_2.bps"
SET SNARFBLASM=%BUILD_DIR%tools\snarfblasm
SET FLIPS=tools\flips
SET DD=tools\dd

CD "%BUILD_DIR%"

IF "%1" == "clean" (
  ECHO Cleaning up generated files...
  DEL src\*.ips
  DEL src\puzzle\model_room.ips
  DEL src\puzzle\chainsaw.ips
  DEL src\puzzle\stairs.ips
  DEL %PATCH_NAME%
  DEL %PATCH_PUZZLE_NAME%
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
%SNARFBLASM% clear_data.asm
%SNARFBLASM% clear_banks.asm
%SNARFBLASM% decompress.asm
%SNARFBLASM% decompressed_tiles.asm
%SNARFBLASM% layout_metadata.asm
%SNARFBLASM% decompressed_layouts.asm
%SNARFBLASM% decompressed_title_screens.asm
%SNARFBLASM% remap_table.asm
CD ..

ECHO Patching...
%FLIPS% src\clear_data.ips %MM_ROM%
%FLIPS% src\decompress.ips %MM_ROM%
%FLIPS% src\remap_table.ips %MM_ROM%
%FLIPS% src\layout_metadata.ips %MM_ROM%
%FLIPS% src\decompressed_layouts.ips %MM_ROM%
%FLIPS% src\patches\maniac_mousedriver.ips %MM_ROM%
%FLIPS% src\patches\hide_keypad.ips %MM_ROM%
%FLIPS% src\patches\hide_pennant.ips %MM_ROM%

%DD% if=%MM_ROM% of=%OUT_ROM%
%DD% if=%MM_ROM% bs=16 skip=1 of=%OUT_ROM% seek=16385

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  git checkout %MM_ROM%
)

ECHO Clearing banks...
%FLIPS% src\clear_banks.ips %OUT_ROM%

ECHO Patching decompressed tiles and layouts...
%FLIPS% src\decompressed_tiles.ips %OUT_ROM%
%FLIPS% src\decompressed_title_screens.ips %OUT_ROM%

IF "%1" == "puzzle" (
  %FLIPS% src\puzzle\puzzle_base.ips %OUT_ROM%
)

ECHO Patching various fixes...
%FLIPS% src\patches\under_house.ips %OUT_ROM%
%FLIPS% src\patches\coin_box.ips %OUT_ROM%
%FLIPS% src\patches\fence_mask.ips %OUT_ROM%
%FLIPS% src\patches\gargoyle_palette.ips %OUT_ROM%
%FLIPS% src\patches\michael_select_palette.ips %OUT_ROM%
%FLIPS% src\patches\developer.ips %OUT_ROM%
%FLIPS% src\patches\radioactive_slime.ips %OUT_ROM%

%FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_NAME%

IF "%1" == "puzzle" (
  ECHO Building puzzle patches...
  CD src\puzzle
  %SNARFBLASM% model_room.asm
  %SNARFBLASM% chainsaw.asm
  %SNARFBLASM% stairs.asm
  CD "%BUILD_DIR%"

  ECHO Patching in puzzle...
  %FLIPS% src\puzzle\model_room.ips %OUT_ROM%
  %FLIPS% src\puzzle\chainsaw.ips %OUT_ROM%
  %FLIPS% src\puzzle\stairs.ips %OUT_ROM%

  %FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_PUZZLE_NAME%
)
