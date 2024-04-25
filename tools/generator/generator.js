const fs = require('node:fs');
const util = require('node:util');
const child_process = require('node:child_process');
const data = require('./data.js');

var romName = './Maniac Mansion (USA).nes';
var scriptsWritePath = './src/scripts/';
var sourceWritePath = './src/';
var descummPath = '.\\tools\\descumm -2 ';

try {
    var rom = fs.readFileSync(romName);
    parseRom(rom);
} catch (err) {
    dumpErr(err);
}

function dumpErr (err)
{
    console.log(err.stack.split("\n").slice(0, 2).join("\n"));
}

function writeFile (filename, content)
{
    try {
        var fd = fs.openSync(filename, 'w');
        fs.writeSync(fd, content);
        fs.closeSync(fd);
    } catch (err) {
        console.log(err.message);
    }
}


function writeScummFiles (basename, content)
{
    var binName = basename + '.bin';
    writeFile(binName, new Uint8Array(content));

    try {
        var scumm = child_process.execSync(descummPath + binName);
    } catch (err) {
        dumpErr(err);
        scumm = "";
    }

    writeFile(basename + '.scumm', scumm);
}

function padScript (bytes)
{
    return [0, 0, 0, 0].concat(bytes);
}

function parseScripts (rom)
{
    var scripts = data.getScriptsData(rom);
    console.log("Generating global scripts...");
    scripts.forEach((script, i) => {
        if (i === 0x3B) { script.raw = script.raw.slice(0, 241); } // work around bad script
        if (script.length) {
            writeScummFiles(scriptsWritePath + 'global_' + script.id, padScript(script.raw));
        }
    });

    var rooms = data.getRoomsData(rom);
    rooms.forEach((room, i) => {
        console.log("Generating scripts for room " + room.id + "...");
        var basename = scriptsWritePath + 'room_' + room.id + '__' + room.name_clean + "_";
        if (room.scripts.entry.raw) {
            writeScummFiles(basename + 'entry', padScript(room.scripts.entry.raw));
        }
        if (room.scripts.exit.raw) {
            writeScummFiles(basename + 'exit', padScript(room.scripts.exit.raw));
        }

        room.objs.forEach((obj, i) => {
            if (obj.scripts.raw.length) {
                writeScummFiles(
                    scriptsWritePath + 'room_' + room.id + '_' +
                    'obj_' + obj.id + '_' + obj.name_clean,
                    padScript(obj.scripts.raw)
                );
            }
        });
    });
}


function writePatchFile (filename, content)
{
    content = Uint8Array.from(Array.from(content).map(v => v.charCodeAt(0)));
    writeFile(sourceWritePath + filename, content);
}

function generatePatchFiles (rom)
{
    var patches = data.getDecompressedData(rom);
    console.log("Generating patches...");

    writePatchFile('clear_data.asm', patches.clearPatch.join("\n"));
    writePatchFile('layout_metadata.asm', patches.layoutMetadataPatch.join("\n"));
    writePatchFile('decompressed_layouts.asm', patches.layoutPatch.join("\n"));
    writePatchFile('remap_table.asm', patches.tilesTablePatch.join("\n"));
    writePatchFile('decompressed_tiles.asm', patches.tilesPatch.join("\n"));
    writePatchFile('decompressed_title_screens.asm', patches.titlePatch.join("\n"));
}


function parseRom (rom)
{
    switch (process.argv[2])
    {
        default:
        case 'scripts':
            parseScripts(rom);
        break;
        case 'patches':
            generatePatchFiles(rom);
        break;
    }
}