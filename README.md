# Maniac Mansion Decoded

Maniac Mansion for the Nintendo Entertainment System uses a simple compression scheme for it's graphics and layouts known as [Run Length Encoding](https://www.nesdev.org/wiki/Tile_compression) (RLE). The encoding makes it very difficult to edit any of the layouts or graphics in the game.

This mod expands the game and decodes all of the encoded data to make it very easy to edit graphics and layouts. The number of tiles for each room is also maximized to make room for new graphics. A lot of space is freed up as a result which makes it easier to edit game objects and text as well. As such, this hack can serve as a base for modifications to Maniac Mansion.

A code example is included which adds a new puzzle chain that modifies existing objects, adds new objects, and adds a whole new room as a final payoff. It does not affect the rest of the game.

Several bugs from the original game are also fixed. More information can be found on [romhacking.net](https://www.romhacking.net/hacks/7776/).

## Building

1. Download or clone this repository.
1. Add your legally obtained copy of `Maniac Mansion (USA).nes` (the "game file") to the repository directory.
1. Run `build.bat` by double clicking it or executing it from a command prompt in the directory of step 1. (Or you can run `build puzzle` from the command prompt to include the custom puzzle code in the patch.)
1. Open the resulting `Maniac Mansion (USA) Decoded.nes` file in the emulator of your choice.
1. Generated files can be cleaned up by running `build clean` from the command prompt.

## Source Code

* The runtime changes that execute during gameplay are found in `src/decompress.asm`.
* The data portions are generated by reading from the original game file and decoding the content into a format suitable for assembly source files that are then compiled into patches during the build process. These source files are generated by code found under `tools/generator` and can be regenerated by running `build patches` from a command prompt.
* Code for the custom puzzle chain can be found in `src/puzzle`.
* The changes for bug fixes to the orginal game are only available as patch files found under `src/patches`.
* During build time the original game file is expanded, the various source files are compiled, and the resulting patches are applied to the expanded game file to produce the final result.
