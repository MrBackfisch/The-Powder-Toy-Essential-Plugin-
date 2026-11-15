Installation

To use this script/plugin in The Powder Toy, you need to place it in your TPT data directory and load it via autorun.lua.

(Note: If you already use the official TPT Script Manager, you can simply drop this script into your scripts folder instead.)

1. Download the Script

Download the .lua file from the Releases page (or clone this repository).

Rename the file to autorun.lua (if you don't already have an autorun.lua file).

2. Find your Data Folder & Install

Windows

Open The Powder Toy.

Go to Settings (the gear icon on the bottom right) and click Open Data Folder.

Alternative: Press Win + R, type %appdata%\The Powder Toy (or %appdata%\Factorious\Powder Toy), and press Enter.

Move the autorun.lua file directly into this folder.

If you already have an autorun.lua: Place this plugin inside your scripts/ subfolder and add dofile("scripts/your_script_name.lua") to your existing autorun.lua (or activate it via your Script Manager).

Linux

Open The Powder Toy.

Go to Settings and click Open Data Folder.

Alternative (Terminal): Depending on your installation (Native, Flatpak, Snap), the folder is usually located at ~/.local/share/The Powder Toy/ or ~/.config/powder toys/.

Move the autorun.lua file directly into this directory:

cp path/to/autorun.lua ~/.local/share/"The Powder Toy"/


(Adjust the target path depending on where your data folder is located).

3. Usage / Verification

Restart The Powder Toy. The script will now load automatically on startup.

(Optional) To test or reload the script manually without restarting, open the in-game console by pressing ~ (or ^ on German keyboards) and type:
