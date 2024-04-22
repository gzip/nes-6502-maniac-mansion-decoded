@ECHO OFF
SETLOCAL
SET MM_ROM="Maniac Mansion (USA).nes"
SET OUT_ROM="Maniac Mansion (USA) Decoded.nes"
SET PATCH_NAME="Maniac Mansion (USA) Decoded v1_2.bps"
SET SNARFBLASM=..\tools\snarfblasm
SET FLIPS=tools\flips
SET DD=tools\dd

IF NOT EXIST %MM_ROM% (
  ECHO "Expected to find the following ROM (see build.bat to edit filename), exiting..."
  ECHO %MM_ROM%
  EXIT /B
)

WHERE /Q git
IF NOT ERRORLEVEL 1 (
  ECHO Checking out clean roms...
  git checkout %MM_ROM%
)

ECHO Building patches...
cd src
%SNARFBLASM% clear_data.asm
%SNARFBLASM% clear_banks.asm
%SNARFBLASM% decompress.asm
%SNARFBLASM% decompressed_tiles.asm
%SNARFBLASM% decompressed_layouts.asm
%SNARFBLASM% decompressed_title_screens.asm
%SNARFBLASM% remap_table.asm
cd ..

ECHO Patching...
%FLIPS% src\clear_data.ips %MM_ROM%
%FLIPS% src\decompress.ips %MM_ROM%
%FLIPS% src\remap_table.ips %MM_ROM%
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

ECHO Patching various fixes...
%FLIPS% src\patches\under_house.ips %OUT_ROM%
%FLIPS% src\patches\coin_box.ips %OUT_ROM%
%FLIPS% src\patches\fence_mask.ips %OUT_ROM%
%FLIPS% src\patches\gargoyle_palette.ips %OUT_ROM%
%FLIPS% src\patches\michael_select_palette.ips %OUT_ROM%
%FLIPS% src\patches\developer.ips %OUT_ROM%
%FLIPS% src\patches\radioactive_slime.ips %OUT_ROM%

%FLIPS% -c --bps %MM_ROM% %OUT_ROM% %PATCH_NAME%
