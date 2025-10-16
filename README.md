# PKG Server 

**⚠️ Warning:** This is still in beta, it may not work.

The AzrovaOS PKG Server provides a package repository for AzrovaOS. It allows users to install, update, and get info about packages over rednet. Each package can include configuration files stored in `/etc/[package]/`.

---

## Features

- Serve packages for AzrovaOS clients (`pkg` command)  
- Packages stored in `/PKGServer/packages/`  
- Configs automatically installed to `/etc/[package]/` on the client  
- Handles multiple clients at once  
- Lightweight and designed for ComputerCraft

---

## File Structure

```

/PKGServer/
server.lua      - Main server script
packages/       - Folder containing all packages

```

Each package should have:  

```

package_name/
files/          - Files to install in /bin or /system
config/         - Optional configuration files for /etc/[package]/
meta.txt        - Metadata or description for the package

```

---

## Example Package

Suppose you have a package called `unzip`:

```

/PKGServer/packages/unzip/
files/unzip.lua
config/unzip.conf
meta.txt

```

- `files/unzip.lua` → will be copied to `/bin/unzip.lua` on the client  
- `config/unzip.conf` → will be copied to `/etc/unzip/unzip.conf`  
- `meta.txt` → contains description: `Unzip utility for AzrovaOS`  

Client command to install:

```

pkg install unzip

```

---

## Installation

1. Place `/PKGServer/` on a ComputerCraft computer.  
2. Ensure `server.lua` exists and `packages/` contains your packages.  
3. Run the server:  
```

/PKGServer/server.lua

```
4. Make sure a wireless modem is attached and working for rednet communication.  

---

## Usage on Client

```

pkg install [package_name]
pkg remove [package_name]
pkg info [package_name]
pkg update [package_name]

```

- The client will ask for the server ID when installing or getting info.  
- Packages automatically create their own config folder in `/etc/[package]/`.  

---

## License

Open-source and free to use. Created by CNethuka for AzrovaOS.
---

If you want, I can also **write the full `server.lua` script** for this PKG Server with proper rednet handling, file transfer, and auto-config creation. This would let you test `pkg install`, `info`, and `update` fully.

Do you want me to do that next?
