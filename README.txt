Maniac Mansion for the Nintendo Entertainment System uses a simple compression scheme for it's
graphics and layouts known as Run Length Encoding (RLE). The encoding makes it very difficult
to edit any of the layouts or graphics in the game.

This hack expands the ROM and decodes all of the encoded data to make it very easy to edit graphics
and layouts. The number of tiles for each room is also maximized to make room for new graphics.
A lot of space is freed up as a result which makes it easier to edit game objects and text as well.
As such, this hack can serve as a base for new hacks such as Maniac Mansion Uncensored.

As a proof of concept, a new puzzle chain is included which modifies existing objects, adds new
objects, and adds a whole new room as a final payoff. It does not affect the rest of the game.
You can select the base patch to omit this addition.

The hack also includes the Maniac Mansion Mouse Hack and fixes a few glitches in the game:

- The glitched graphics in the room under the house are fixed
- The glitched coin box graphics in the arcade are fixed
- The glitched graphics for the developer under the house are fixed
- The leftover pennant object in Weird Ed's room is removed
- The leftover keypad object in the hallway is removed
- The interactivity for the radioactive slime in the basement is restored
- The fence mask is fixed in the starting screen so that the player is completely behind it
- The colors for the right-side gargoyle on the stairs are corrected
- The border color is fixed when selecting Michael on the character select screen
- The meteor's sprite graphics are fixed
- The Lucasfilm logo is centered vertically and the misplaced shine sprite is fixed

The following optional patches are applied by default:

- char_select.ips - Adds rounded corners to the character select screen.
- fridge.ips - Rearranges the fridge to recolor the lettuce green and the batteries brown.
- portraits.ips - Improves the various portraits in the house, including Fred in Edna's room, Edna in Fred's room, Fred in Edna's attic, and the family portrait in the den.
- title_screen.ips - Uses the title screen from the Japanese version, which is based on the C64 graphics. (Not included in default patches, must be applied separately.)
- under_house_enhanced.ips - Improves the post and valve graphics and fixes the background mask.

You can select the base patch to omit these additions.


Patching

Use the online patcher at romhacking.net (or the patcher of your choice) to apply the bps patch to:

ROM info:

Database match: Maniac Mansion (USA)

File SHA-1: 7317D1F1096B57F6AB8F3001BCDD35665C291B1A
File CRC32: 68309D06
ROM SHA-1: 8A8BBECC77FDF59826257754F357D38A7F825971
ROM CRC32: D9F5BD1

Source Code

Source code is available on github:
https://github.com/gzip/nes-6502-maniac-mansion-decoded/
