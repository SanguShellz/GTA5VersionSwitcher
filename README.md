### THIS IS NOT USED TO INTIALLY INSTALL THE VR MOD.  THAT HAS TO BE SETUP INDEPENDENTLY 
https://www.youtube.com/watch?v=LO_jDnHO0Kk

# GTA5 Version Switcher

## Overview
This tool lets you easily switch between different versions of GTA V. You can go back to an older version, use a modded setup (like R.E.A.L. VR, Geo11, or updated mods that don't work with R.E.A.L. VR), or return to the original vanilla version for online play or updates. Just follow the steps below to set up and use the installer.

---

## Setup Instructions

### 1. Configure `config.txt`

Edit `config.txt` to define the following paths:

- **`GTAV_DIR`**  
  Path to the game directory where GTA V is installed.

- **`ALT_VERSION_DIR`**  
  Directory to store an alternate version of the GTA V install (e.g., an older version, VR mod).  
  Upon installation of the alternate version, required files for the current GTA V version are backed up to a `default_files_backup` folder inside the game directory.

- **`CURRENT_VERSION_DIR`**  
  Directory containing files to be transferred to the game directory for the current GTA V version (e.g., `.ini`, `.dll` files).  
  This directory can remain empty, but it **must exist**.  
  Files in this directory will be copied to or deleted from the game directory depending on the selected version.

- **`SETTINGS_DIR`**  
  Path to the folder containing the GTA V `settings.xml`.

---

### 2. Add Game Settings

Place a custom `settings.xml` file into the appropriate folder depending on the version you're using:

- **Alt Version** – for the alternative setup (e.g., VR)
- **Current Version** – for your primary GTA V installation

---

### 3. Run the Installer

Run the `GTA5 Version Swithcer.bat` to install or remove an alternate version of GTA V.

> On first run, the script will create two files:  
> - `AltVersionList.txt`  
> - `CurrentVersionList.txt`  
>
> These files index the contents of the respective version directories for accurate restoration and uninstallation later.

---

## Notes

- Ensure all directory paths are correctly set in `config.txt` before running the script.
- Always back up your game data before making changes.
