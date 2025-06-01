>### 📣 IMPORTANT !!
>⚠️Please back up your game files before using this tool for the first time. Use at your own risk

# GTA5 Version Switcher

## Overview
This tool lets you easily switch between different versions of GTA V. You can go back to an older version, use a modded setup (like REAL VR, Geo11, or updated mods that don't work with RRAL VR), or return to the original vanilla version for online play or updates. Just follow the steps below to set up and use the switcher.

---

## Setup Instructions

### 1. Configure `config.txt`

Edit `config.txt` to define the following paths:

- **`GTAV_DIR`**  
  Path to the game directory where GTA V is installed.

- **`ALT_VERSION_DIR`**  
  -D irectory to store an alternate version of the GTA V install (REAL VR, Geo11, or updated mods that don't work with RRAL VR).  
  - When first switching to the alternate version, required files for the Primary ovanilla version of GTA V are backed up to a geeerated `default_files_backup` folder inside the game directory.  Yuu may need to run the batch as admin to create the folder.

- **`Primary_VERSION_DIR`**  
  Folder containing files that will be moved the GTA V game isntall directory (e.g., `.ini`, `.dll` files).  
  This directory can remain empty, but it **must exist**.  
  Files in this directory will be copied to or deleted from the game directory depending on selection made in the batch CLI.

- **`SETTINGS_DIR`**  
  Path to the folder containing the GTA V `settings.xml`.

---

### 2. Add Game Settings

This copies your custom `settings.xml` file into the documents folder ovewriting the settings.xml that's presently there:

- **Alt Version** – for the alternative setup (e.g., VR)
- **Primary Version** – for your primary GTA V installation

---

### 3. Run the Installer

Run the `GTA5 Version Swithcer.bat` to install or remove an alternate version of GTA V.

> On first run, the script will create two files:  
> - `AltVersionList.txt`  
> - `PrimaryVersionList.txt`  
>
> These files index the contents of the respective version directories for accurate restoration and uninstallation later.

---

### Ensure all directory paths are correctly set in `config.txt` before running the script.

