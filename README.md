# Minecraft Server Management

This repository contains the configuration and assets for my personal Minecraft server. The server is managed using Docker Compose with the `itzg/minecraft-server` image.

## Resource Pack Workflow

The server is configured to automatically provide a single, merged resource pack to all players upon joining. This pack is named `pack.zip` and is hosted in this repository.

To update or change the active resource pack, follow these steps in the terminal from the project's root directory.

### Step 1: Preparation

Place the base resource pack and any overlay/add-on packs (like a font pack) into this directory.

For this example, we'll assume:
- `stay_true_1.20.zip` (the base pack)
- `improved_fonts_1.0.zip` (the overlay pack)

### Step 2: Merge and Create Versioned Pack

The following commands will merge the packs into a single, descriptively named `.zip` file.

```bash
# Define file names for clarity
BASE_PACK="stay_true_1.20.zip"
OVERLAY_PACK="improved_fonts_1.0.zip"
FINAL_PACK_NAME="StayTrue-With-ImprovedFonts-1.20.zip"

# Create a temporary directory for merging
mkdir temp_pack
cd temp_pack

# Unzip the base pack, then the overlay pack on top to merge
unzip "../${BASE_PACK}"
unzip "../${OVERLAY_PACK}"

# Create the new, descriptively named merged zip file
zip -r "../${FINAL_PACK_NAME}" .

# Clean up the temporary directory
cd ..
rm -rf temp_pack

# set the newly created pack as the default
cp "${FINAL_PACK_NAME}" pack.zip