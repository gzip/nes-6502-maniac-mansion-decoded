var result = [];

var verbNames = [
    "",
    "Open",
    "Close",
    "Give",
    "TurnOn",
    "TurnOff",
    "Fix",
    "NewKid",
    "Unlock",
    "Push",
    "Pull",
    "Use",
    "Read",
    "WalkTo",
    "Get",
    "WhatIs",
    "Lock"
];
verbNames[255] = "All";

var roomNames = [
    "Crash",
    "Front Yard",
    "Bottom of Pool",
    "Living Room",
    "Dungeon",
    "Library",
    "Swimming Pool",
    "Kitchen",
    "Basement",
    "Attic 1 (Safe Room)",
    "Main Entry Way",
    "Hallway 1 (Entry Way)",
    "Entryway 2 (to Darkroom)",
    "2nd Floor Hallway",
    "Painting Room",
    "Attic 2 (Wires)",
    "Garage",
    "Music Room",
    "Arcade",
    "Edna's Room",
    "Tentacle's Room",
    "Fred's Room",
    "Fred's Office",
    "Darkroom",
    "Ted's Bathroom",
    "Ted's Room",
    "Weird Ed's Room",
    "Den",
    "Observatory",
    "Under House",
    "Ready Room",
    "Laboratory",
    "911 Cutscene",
    "Meteor Crash Cutscene",
    "Safe's Password",
    "Telescope Alien Cutscene",
    "Pantry",
    "Dining Room",
    "Top Hallway",
    "Arcade High Score",
    "Inside Television",
    "Television Network Room",
    "Talk Show",
    "Phone Numbers",
    "Driveway",
    "Pick Kids",
    "Car Fly Cutscene",
    "Bad Ending Cutscene",
    "Meteor in Car Ending Cutscene",
    "Title Screen",
    "Pause Menu",
    "Meteor Room",
    "Garage Destroyed",
    "Beta Character Select",
    "Telescope Cutscene Outside",
    "Grey",
    "Crash"
];

function toHex (dec, pad)
{
    var hex = dec.toString(16).toUpperCase();
    var len = hex.length;
    return pad !== false && len < 5 && (len % 2) ? "0"+hex : hex;
}

function toDec (hex)
{
    return parseInt(hex, 16);
}

function toBin(val)
{
  val = toDec(val).toString(2);
  return "00000000".substr(0, 8 - val.length) + val;
}

function getDataRange (data, start, end, bitMask, bitShiftRight)
{
    var chunk = [];

    // allow length to be passed as end
    if (end < start) {
        end = start + end - 1;
    }

    var uint8ArrayChunk = data.slice(start, (end || start) + 1);

    uint8ArrayChunk.forEach(function (val)
    {
        if (bitMask) {
            val = val & bitMask;
        }
        if (bitShiftRight) {
            val = val >> bitShiftRight;
        }
        chunk.push(val);
    });

    return chunk;
}

function getBankOffset (bank)
{
    var offset = (bank - 2) * 0x4000;
    return offset;
}

function getPointer (data, addr)
{
    var ref = getDataRange(data, addr || 0, (addr || 0) + 1);
    var pointer = ((ref[1] << 8) + ref[0]);
    return pointer;
}

function getRomPointer (data, bank, addr)
{
    var offset = getBankOffset (bank);
    var pointer = getPointer(data, addr) + offset + 0x10;
    return pointer;
}

function getPointers (data, addr, count, bank)
{
    return chunkArray(getDataRange(data, addr, addr + (count * 2) - 1), 2).map(grp => getPointer(grp, 0, bank));
}

function getMemFromRom (addr, offset)
{
    var bank = Math.floor(addr / 0x4000);
    var addr = addr % 0x4000 + 0x8000 - 0x10 + (offset || 0);
    return {bank: bank, addr: addr};
}

function chunkArray (ar, size)
{
    var result = [];
    for (var a = 0, al = ar.length; a < al; a += size) {
        result.push(ar.slice(a, a + size));
    }
    return result;
}

function getZeroTerminatedData (data, addr)
{
    var end = data.indexOf(0, addr);
    var val = data.slice(addr, end);
    return val;
}

function getDataString (data, addr)
{
    var str = getZeroTerminatedData(data, addr);
    return str.map((val)=>String.fromCharCode(val)).join("");
}

function formatData (data, chunkSize)
{
    // split into columns of 16 bytes
    return chunkArray(data, chunkSize || 16).map(v=>v.join(" ")).join("\n");
}

function formatPatchData (data, comment)
{
    return ".data $" + data.join(", $") + (comment ? " ; " + comment : "");
}

function pushBuffer (data, buffer, ctrlByte)
{
    if (ctrlByte) { data.push(toHex(ctrlByte)) };
    Array.prototype.push.apply(data, buffer);
    buffer.length = 0;
}

function pushRepeatBuffer (data, buffer)
{
    pushBuffer(data, [buffer[0]], buffer.length);
    buffer.length = 0;
}

function compressChunkedData (data, entrySize)
{
    data = chunkArray(data, entrySize);

    var compressed = [];

    data.forEach(function eachChunk (entry, i)
    {
        compressed = compressed.concat(compressData(data[i]));
    });

    return compressed;
}

function compressData (data)
{
    var compressed = [], repeatBuffer = [], rbl, byteBuffer = [], bbl;

    if (typeof data === "string") {
        data = data.replace(/\s+/g, "").match(/.{2}/g);
    }

    for (var byte, i = 0, dl = data.length; i <= dl; i++)
    {
        byte = data[i];

        while (byte && byte === data[i+1]) {
            repeatBuffer.push(byte);
            byte = data[++i];
        }

        if (repeatBuffer.length) {
            repeatBuffer.push(repeatBuffer[0]);
        }

        rbl = repeatBuffer.length;
        bbl = byteBuffer.length;

        if (rbl === 0 && byte !== undefined) {
            byteBuffer.push(byte);
        } else if (rbl > 2) {
            if (bbl) {
                pushBuffer(compressed, byteBuffer, 0x80 + bbl);
            }
            pushRepeatBuffer(compressed, repeatBuffer);
        } else {
            pushBuffer(byteBuffer, repeatBuffer);
        }

        if (byte === undefined && bbl) {
            pushBuffer(compressed, byteBuffer, 0x80 + bbl);
        }
    }
    return compressed;
}

function verifyData (data, start, end)
{
    return true;
}

function decompressData (data, start, end, maxEntries, entrySize)
{
    // save to globals
    result = [];
    rleData = getDataRange(data, start, end).map(toHex);

    var dec;
    var raw = [];
    var entry = [];
    var overflow = [];
    var rawOverflow = [];

    var addr, byte, c, count, isRun = false;

    if (!entrySize) {
        entrySize = 16;
    }

    for (var byte, i = 0, dl = rleData.length; i < dl; i++)
    {
        if (maxEntries && result.length === maxEntries) {
            break;
        }

        if (rleData.hasOwnProperty(i))
        {
            byte = rleData[i];
            dec = toDec(byte);

            // store the raw value
            raw.push(byte);

            isRun = dec > 0x80;

            if (isRun) {
                count = dec - 0x80;
            } else {
                count = dec;
                byte = rleData[++i];
                raw.push(byte);
            }

            while (count > 0)
            {
                if (isRun) {
                    byte = rleData[++i];
                }

                if (entry.length < entrySize) {
                    entry.push(byte);
                    if (isRun) {
                        raw.push(byte);
                    }
                } else {
                    overflow.push(byte);
                    if (isRun) {
                        rawOverflow.push(byte);
                    }
                }

                count--;
            }

            // increment start for next entry
            start += raw.length;

            // push data when a full entry is found (16 bytes)
            if (entry.length >= entrySize)
            {
                result.push({
                    rom: toHex(start),
                    "raw": raw,
                    "length": raw.length,
                    expanded: entry
                });

                // reset containers
                raw = [];
                entry = [];
                if (overflow.length)
                {
                    entry = overflow;
                    raw = rawOverflow;

                    // handle overflow > 16
                    while (entry.length >= entrySize && (!maxEntries || result.length < maxEntries))
                    {
                        if (isRun)
                        {
                            start += entrySize;
                            result.push({
                                "rom": toHex(start),
                                "raw": raw.slice(0, entrySize),
                                "length": entrySize,
                                "expanded": entry.slice(0, entrySize)
                            });
                            raw = raw.slice(entrySize);
                        }
                        else
                        {
                            result.push({
                                "rom": toHex(start),
                                "raw": [],
                                "length": 0,
                                "expanded": entry.slice(0, entrySize)
                            });
                        }

                        entry = entry.slice(entrySize);
                    }

                    overflow = [];
                    rawOverflow = [];
                }
            }
        }
    }

    return result;
}

function getTableData (romData, addr, len)
{
    var table = chunkArray(getDataRange(romData, addr, len), 4);
    table.map(function (bytes, i)
    {
        table[i] = {
            raw:   bytes.map(toHex).join(" "),
            bytes: bytes,
            bank:  bytes[0],
            mem:   getPointer(bytes, 2),
            rom:   getRomPointer(bytes, bytes[0], 2)
        };
    });
    return table;
}

function getRoomsData (romData)
{
    var rooms = [];
    var table = getTableData(romData, 0x3DCA5, 220);
    var objStates = getDataRange(romData, 0x2CA21, 647);
    table.forEach(function eachRoom (room, r)
    {
        room.name = roomNames[r];
        room.name_clean = room.name.toLowerCase().replace(/ /g, "_").replace("'", "");
        room.id = toHex(r, true);
        room.len = getPointer(romData, room.rom);
        room.data = getDataRange(romData, room.rom, room.len);
        room.numObjs = room.data[0x14];
        var exitScriptOffset = getPointer(room.data, 0x18);
        var entryScriptOffset = getPointer(room.data, 0x1A);
        room.scripts = {
            exit: exitScriptOffset && {
                offset: toHex(exitScriptOffset),
                rom: toHex(room.rom + exitScriptOffset),
                data: room.data.slice(exitScriptOffset, entryScriptOffset).map(toHex).join(" "),
                raw: room.data.slice(exitScriptOffset, entryScriptOffset)
            } || {},
            entry: entryScriptOffset && {
                offset: toHex(entryScriptOffset),
                rom: toHex(room.rom + entryScriptOffset),
                data: room.data.slice(entryScriptOffset).map(toHex).join(" "),
                raw: room.data.slice(entryScriptOffset)
            } || {}
        };
        room.tileIndex = room.data[getPointer(room.data, 0x0A)] || 0;
        room.unknown = getDataRange(room.data, 0x1C + room.numObjs * 4, 4);
        room.objs = [];

        var objPointers = room.numObjs ? getPointers(room.data, 0x1C + room.numObjs * 2, room.numObjs, room.bank) : [];
        var objGfxStateChanges = room.numObjs ? getPointers(room.data, 0x1C, room.numObjs, room.bank) : [];
        objPointers.forEach(function eachObj (offset, o)
        {
            var len = getPointer(room.data, offset);
            var rom = room.rom + offset;
            var objData = getDataRange(room.data, offset, offset + len - 1);

            var id = getPointer(objData, 0x04);
            var nameStart = objData[0x0E];
            var name = getDataString(objData, nameStart);

            var verbData = getZeroTerminatedData(objData, 0x0F);
            var codeStart = verbData.length ? nameStart + name.length + 1 : 0;

            var verbPairs = {};
            for (var v = 0, vl = verbData.length; v < vl; v +=2)
            {
                var verbOffset = verbData[v+1];
                var verbName = verbNames[verbData[v]];
                verbPairs[verbName] = {
                    offset: toHex(verbOffset),
                    code_offset: toHex(verbOffset - codeStart),
                    rom: toHex(rom + verbOffset)
                };
            }

            room.objs[o] = {
                num: o + 1,
                len: len,
                offset: toHex(offset, true),
                rom: toHex(rom),
                id: (id < 255 ? "00" : "") + toHex(id),
                name: name,
                name_clean: name.toLowerCase().replace(/ /g, "_").replace("'", ""),
                verbs: verbPairs,
                state: {
                    initial: toHex(objStates[id]),
                    ram: toHex(0x660A + id),
                    rom: toHex(0x2CA21 + id)
                },
                stateChange: {
                    offset: toHex(objGfxStateChanges[o]),
                    rom: toHex(room.rom + objGfxStateChanges[o])
                },
                scripts: {
                    offset: toHex(codeStart),
                    rom: toHex(rom + codeStart),
                    data: codeStart ? objData.slice(codeStart).map(toHex).join(" ") : "",
                    raw: codeStart ? objData.slice(codeStart) : []
                }
            };
        });

        rooms.push(room);
    });

    return rooms;
}

function getScriptsData (romData)
{
    var scripts = [];
    var scriptCount = 179;
    var scriptsAddr = 0x3EA5B;

    var banks   = getDataRange(romData, scriptsAddr, scriptCount);
    var addrsLo = getDataRange(romData, scriptsAddr + scriptCount, scriptCount);
    var addrsHi = getDataRange(romData, scriptsAddr + scriptCount + scriptCount, scriptCount);

    for (var i = 0; i < scriptCount; i++) {
        var romAddr = banks[i] == 255 ? 0 : getRomPointer([addrsLo[i], addrsHi[i]], banks[i]);
        // length includes the 4 byte header so subtract that
        var headLen = 4;
        var len = romAddr ? getPointer(romData, romAddr) - headLen : 0; // TODO: what are the next 2 bytes used for?
        scripts.push({
            index:  i,
            id:     toHex(i),
            bank:   toHex(banks[i]),
            addr:   toHex(addrsHi[i]) + toHex(addrsLo[i]),
            rom:    romAddr,
            length: len,
            header: romAddr ? getDataRange(romData, romAddr, headLen).map(toHex).join(" ") : "",
            data:   romAddr ? getDataRange(romData, romAddr + headLen, len).map(toHex).join(" ") : "",
            raw:    romAddr ? getDataRange(romData, romAddr + headLen, len) : []
        });
    }

    return scripts;
}

function getDecompressedData (romData)
{
    var data = [];
    var lines = [];

    // parse the whole table and supplement common info
    var tableAddr = 0x3DC05;
    var titleTableAddr = 0x2447;
    var table = getTableData(romData, tableAddr, 408);//.
        // hack on title section tiles
        //concat(getTableData(romData, titleTableAddr, 8));

    var padTiles = true;
    var delimiterTile = "00 42 00 18 18 00 42 00 00 00 24 18 18 24 00 00".split(" ");

    var clearPatch = ["; clear out compressed graphics data"];
    var tilesTablePatch = ['; patch tiles table to point to new uncompressed tiles'];
    var tilesPatch = ["; patch in uncompressed graphics data"];
    var layoutMetadataPatch = ["; patch layout metadata to point to new tables"];
    var layoutPatch = ["; patch in uncompressed nametables and attribute tables"];
    var titlePatch = ["; patch in uncompressed tiles, nametables and attribute tables for title screens"];

    var len_total = 0;
    var xlen_total = 0;

    // starting bank for expanded graphics
    var bankNum = 17;
    var bankBytes = 0;

    // parse graphics section + sprites section + title section
//    table.slice(0,40).concat(table.slice(100)).forEach(function (entry, i, entries)
    table.slice(0,40).forEach(function (entry, i, entries)
    {
        var num;
        var numOffset = 0;

        // title is handled differently
        if (i > 41) {
            numOffset = 4;
            num = romData[entry.rom + numOffset];
            num++;
        } else {
            // first byte in the entry is the number of tiles
            num = romData[entry.rom];
        }
        entry.num = num;

        // compressed data starts one byte after the number of tiles
        var decompressed = decompressData(romData, entry.rom + numOffset + 1, (num || 256) * 16, num || 256);

        // vars to store the overall length and eXpanded length
        entry.len = 0;
        entry.xlen = 0;

        decompressed.forEach(e => {
            entry.len += e.length;
            entry.xlen += e.expanded.length;
            len_total += e.length;
            xlen_total += e.expanded.length;
        });

        var sprites = i > 39 && i < 42;

        // optionally pad the graphics for extra tiles, ignore sprites
        if (padTiles && i && !sprites)
        {
            var limit = i < 40 ? 0x9D : 0xEF;

            // fill up the page
            while (decompressed.length < limit + 1)
            {
                decompressed.push({expanded: delimiterTile});
                entry.num++;
                entry.xlen += 16;
            }
        }

        entry.decompressed = decompressed;

        // blank out data
        clearPatch.push([
            "",
            ".PATCH " + toHex(entry.bank) + ":" + toHex(entry.mem) + " ; tiles entry $" + toHex(i),
            "  .dsb $" + toHex(entry.len + 1) + ", $FF"
        ].join("\n"));

        if (i < 42)
        {
            // increment bank if this one is already full
            if (bankBytes + entry.xlen > 16384)
            {
                bankBytes = 0;
                bankNum++;
            }

            // rebuild table entry
            var mem = toHex(bankBytes + 0x8000);
            var bytes = [
                bankNum - 16,
                entry.num,
                toDec(mem.substr(2)),
                toDec(mem.substr(0,2))
            ];

            // rewrite title entry
            var j = i < 40 ? i : i + 60;
            table[j].bytes = bytes;

            // start new bank if just incremented
            if (bankBytes === 0) {
                tilesPatch.push("\n\n.PATCH " + toHex(bankNum) + ":8000");
            }

            // output the bytes
            tilesPatch.push("\n; tiles entry $" + toHex(i) + " (" + entry.xlen + " total bytes) " +
                          "[$" + toHex(0x8000 + bankBytes + getBankOffset(bankNum) + 0x10) + "]");

            decompressed.forEach((e,t) => {
                tilesPatch.push( formatPatchData(e.expanded, "tile $" + toHex(t + (i === 0 || sprites ? 0 : 0x62))) );
            });

            // track number of bytes for this bank
            bankBytes += entry.xlen;
        }

        lines.push(
            toHex(i) + ": " +
            entry.raw + " :: bank: " + toHex(entry.bank) +
            ", mem: " + toHex(entry.mem) +
            ", rom: " + (toHex(entry.rom).length < 5 ? " " : "") + toHex(entry.rom) +
            ", num: " + ((entry.num || 255) < 100 ? " " : "") + (entry.num || 255) +
            ", len: " + (entry.len < 1000 ? " " : "") + (entry.len || "n/a") +
            ", xlen: "+ (entry.xlen < 1000 ? " " : "") + (entry.xlen || "n/a")
        );
    });

    if (len_total) {
        lines.push("                                                        total_len: " + len_total);
        lines.push("                                                                   total_xlen: " + xlen_total);
    }

    // starting bank for expanded tables
    bankNum = 0x01;
    bankBytes = 0;

    clearPatch.push("\n\n ; clear out nametable and attribute table data");

    // parse nametable and attribute table section, including title sections
    //table.slice(40, 95).concat(table.slice(102,104)).forEach(function (entry, i)
    table.slice(40, 95).forEach(function (entry, i)
    {
        var isRoom = i < 0x37;
        if (entry.mem !== 0)
        {
            if (isRoom)
            {
                var layoutObjectSize = getPointer(romData, entry.rom);

                // grab the metadata which will be patched later
                var layoutMetadata = getDataRange(romData, entry.rom + 4, 16);
                var chunkSize = layoutMetadata[0];
                var rows = layoutMetadata[2]; // always 16

                // seventh byte of the layout data gives the tiles index offset
                var baseRomLocation = getRomPointer(layoutMetadata, entry.bank, 6) + entry.mem;
                var tilesEntryIndex = romData[baseRomLocation];
                var palette = getDataRange(romData, baseRomLocation + 1, 16);

                // then the nametable
                var ntRomLocation = baseRomLocation + palette.length + 1;
                var nametable = decompressData(romData, ntRomLocation, ntRomLocation + chunkSize * rows, rows, chunkSize);

                // eighth byte of the layout data
                var atRomLocation = getRomPointer(layoutMetadata, entry.bank, 8) + entry.mem;
                var attrTable = decompressData(romData, atRomLocation, ((chunkSize >> 2) + 1) * 4 + 10, 4, (chunkSize >> 2) + 1);

                // include tiles entry in output
                entry.tiles_entry = tilesEntryIndex;
                entry.tiles_entry_rom = baseRomLocation;
            }
            else // for the title section we parse tiles, nametable, attribute table, and palette all at once
            {
                var romLocation = entry.rom;
                for (var j = 0; j < 3; j++)
                {
                    var prologue = getDataRange(romData, romLocation, 5);
                    var mdl = prologue.length;
                    var chunkSize = prologue[3] + 1;
                    var rows = prologue[4] + 1;

                    romLocation += mdl;

                    // always decompress in order to find the next section
                    var decompressed = decompressData(romData, romLocation, romLocation + chunkSize * rows, rows, chunkSize);

                    switch (j)
                    {
                        case 0:
                            // interested in entries 102 and 103
                            var tiles = table[101 + i - 0x36];
                            var tilePrologue = prologue;
                            // update count to padded number (incremented by 1 in the asm)
                            tilePrologue[4] = entry.num - 1;
                        break;
                        case 1:
                            var ntRomLocation = romLocation;
                            var ntPrologue = prologue;
                            var ntChunkSize = chunkSize;
                            var ntRows = rows;
                            var nametable = decompressed;
                        break;
                        case 2:
                            var atRomLocation = romLocation;
                            var atPrologue = prologue;
                            var atChunkSize = chunkSize;
                            var atRows = rows;
                            var attrTable = decompressed;
                        break;
                    }

                    // set the next rom location
                    decompressed.forEach(entry => romLocation += entry.length);

                    // grab the entire palette section to output as-is
                    if (j === 2) {
                        var pal = getDataRange(romData, romLocation, 18); // step# + palette + $FF
                    }
                }
            }

            // vars to store the compressed (rle) and expanded lengths
            entry.nt_rom = ntRomLocation;
            entry.nt_rlen = 0;
            entry.nt_xlen = 0;

            nametable.forEach(e => {
                entry.nt_rlen += e.length;
                entry.nt_xlen += e.expanded.length;
            });

            // add up lengths for attribute table as well
            entry.at_rom = atRomLocation;
            entry.at_rlen = 0;
            entry.at_xlen = 0;

            attrTable.forEach(e => {
                entry.at_rlen += e.length;
                entry.at_xlen += e.expanded.length;
            });

            // add bytes for metadata if title tables
            entry.total_rlen = entry.nt_rlen + entry.at_rlen + (isRoom ? 0 : mdl * 3 + pal.length);
            entry.total_xlen = entry.nt_xlen + entry.at_xlen;

            clearPatch.push([
                "",
                ".PATCH $" + toHex(entry.nt_rom) + " ; " + (isRoom ? "room" : "title") + " entry $" + toHex(i),
                "  .dsb $" + toHex(entry.total_rlen + (isRoom ? 0 : 4)) + ", $FF"
            ].join("\n"));


            if (isRoom)
            {
                // increment bank if this one is already full
                // (and leave a bit of space at the end of the bank for residual data)
                if (bankBytes + entry.total_xlen > 16128)
                {
                    bankBytes = 0;
                    bankNum++;
                }

                // start new bank if just incremented
                if (bankBytes === 0) {
                    layoutPatch.push("\n.PATCH " + toHex(bankNum) + ":8000");
                }

                // set new bank and mem location
                var nt_mem = toHex(0x8000 + bankBytes);
                layoutMetadata[3] = toHex(bankNum);
                layoutMetadata[4] = nt_mem.substr(2);
                layoutMetadata[5] = nt_mem.substr(0, 2);

                // update attribute table pointer offsets
                var at_mem = toHex(entry.nt_xlen);
                layoutMetadata[8] = at_mem.substr(2);
                layoutMetadata[9] = at_mem.substr(0, 2);

                // patch the layout entry metadata
                layoutMetadataPatch.push("\n.PATCH $" + toHex(entry.rom + 4) + " ; room entry $" + toHex(i));
                layoutMetadataPatch.push(formatPatchData(layoutMetadata.map(toHex)));

                // track number of bytes for this bank
                bankBytes += entry.total_xlen;

                // output the bytes
                layoutPatch.push("\n; layout entry $" + toHex(i) + " in bank $" + toHex(bankNum) + " at RAM $" + nt_mem +
                                 " / ROM $" + toHex(toDec(nt_mem) + getBankOffset(bankNum) + 0x10) +
                                 " (" + entry.total_xlen + " total bytes)");

                layoutPatch.push('; nametable');
                nametable.forEach((e,i) => {
                    layoutPatch.push(formatPatchData(e.expanded));
                });

                layoutPatch.push('; attribute table');
                attrTable.forEach((e,i) => {
                    layoutPatch.push(formatPatchData(e.expanded));
                });
            }
            else
            {
                // determine patch addresses
                i -= 0x36;
                var ptrAddr = i === 1 ? 0xA439 : 0xA43D;
                var memAddr = 0xA63B;
                bankNum = i === 1 ? 0 : 16; // first bank or the 17th

                // patch the relevant pointer
                titlePatch.push("\n; title screen pointer $" + toHex(i));
                titlePatch.push(".PATCH " + toHex(bankNum) + ":" + toHex(ptrAddr));
                titlePatch.push(".word $" + toHex(memAddr));

                // patch the decompressed bytes
                titlePatch.push("\n; title screen $" + toHex(i) + " in bank $" + toHex(bankNum) +
                                 " (" + (mdl * 3 + tiles.xlen + entry.total_xlen + pal.length) + " total bytes)");

                titlePatch.push(".PATCH " + toHex(bankNum) + ":" + toHex(memAddr));

                titlePatch.push('; tiles');
                titlePatch.push(formatPatchData(tilePrologue.map(toHex), "prologue"));
                tiles.decompressed.forEach((e, i) => {
                    titlePatch.push(formatPatchData(e.expanded, 'tile $' + toHex(i)));
                });

                titlePatch.push('\n; nametable');
                titlePatch.push(formatPatchData(ntPrologue.map(toHex), "prologue"));
                nametable.forEach((e,i) => {
                    titlePatch.push(formatPatchData(e.expanded));
                });

                titlePatch.push('\n; attribute table');
                titlePatch.push(formatPatchData(atPrologue.map(toHex), "prologue"));
                attrTable.forEach((e,i) => {
                    titlePatch.push(formatPatchData(e.expanded));
                });

                titlePatch.push('\n; palette');
                titlePatch.push(formatPatchData(pal.map(toHex)));
            }
        }

        lines.push(
            toHex(i) + ": " +
            entry.raw + " :: bank: " + toHex(entry.bank) +
            ", mem: " + toHex(entry.mem) +
            ", rom: " + (entry.rom.length < 5 ? " " : "") + toHex(entry.rom) +
            (entry.tiles_entry ? " :: tiles_entry: " + toHex(entry.tiles_entry) + " [" + toHex(entry.tiles_entry_rom) + "]" : "") +
            (entry.nt_rom ? (" :: nt_rom: " + (entry.nt_rom < 5 ? " " : "") + toHex(entry.nt_rom)) : "") +
            (entry.nt_rlen ? (", nt_rlen: " + (entry.nt_rlen < 10 ? " " : "") + entry.nt_rlen) : "") +
            (entry.nt_xlen ? (", nt_xlen: " + entry.nt_xlen) : "") +
            (entry.at_rom ? (" :: at_rom: " + (entry.at_rom < 5 ? " " : "") + toHex(entry.at_rom)) : "") +
            (entry.at_rlen ? (", at_rlen: " + (entry.at_rlen < 10 ? " " : "") + entry.at_rlen) : "") +
            (entry.at_xlen ? (", at_xlen: " + entry.at_xlen) : "") +
            (entry.total_rlen ? (" :: total_rlen: " + entry.total_rlen) : "") +
            (entry.total_xlen ? (", total_xlen: " + (entry.total_xlen < 1000 ? " " : "") + entry.total_xlen) : "")
        );
    });

    tilesTablePatch.push("\n.PATCH $" + toHex(tableAddr));
    for (var i = 0; i < 40; i++) {
        tilesTablePatch.push( formatPatchData(table[i].bytes.map(toHex), "tiles entry $" + toHex(i)) );
    }

    // patch table sprites data
    tilesTablePatch.push("\n.PATCH $" + toHex(0x3DD95));
    for (i = 100; i < 102; i++) {
        tilesTablePatch.push( formatPatchData(table[i].bytes.map(toHex), "sprites entry $" + toHex(i)) );
    }

    return {
        lines: lines,
        clearPatch: clearPatch,
        layoutMetadataPatch: layoutMetadataPatch,
        layoutPatch: layoutPatch,
        tilesTablePatch: tilesTablePatch,
        tilesPatch: tilesPatch,
        titlePatch: titlePatch
    }
}

if (typeof module !== "undefined")
module.exports = {
    toHex: toHex,
    getDecompressedData: getDecompressedData,
    getRoomsData: getRoomsData,
    getScriptsData: getScriptsData,
    getTableData: getTableData
}
