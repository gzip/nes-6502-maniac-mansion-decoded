# Maniac Mansion Decoded

Maniac Mansion for the Nintendo Entertainment System uses a simple compression scheme for it's
graphics and layouts known as  [Run Length Encoding](https://www.nesdev.org/wiki/Tile_compression) (RLE). The encoding makes it very difficult
to edit any of the layouts or graphics in the game.

This mod expands the game and decodes all of the encoded data to make it very easy to edit graphics
and layouts. The number of tiles for each room is also maximized to make room for new graphics.
A lot of space is freed up as a result which makes it easier to edit game objects and text as well.
As such, this hack can serve as a base for modifications to Maniac Mansion.

Several bugs from the original game are also fixed. More information can be found on [romhacking.net](https://www.romhacking.net/hacks/7776/).

## Building

1. Download or clone this repository.
2. Add your legally obtained copy of `Maniac Mansion (USA).nes`.
4. Run `build.bat` from a command prompt in the directory in step 1 or by double clicking it.
5. Open the resulting `Maniac Mansion (USA) Decoded.nes` in the emulator of your choice.
