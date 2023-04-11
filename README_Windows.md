# Running muforth on Windows 11 via WSL2 

muforth will run on Windows 11 via wsl2 without too much effort if your
PC supports the hypervisor.  How to configure your machine, setup wsl2
to work with the hypervisor and install one of the linux options is
outside the scope of this document.

Likewise, so is setting up your dev environment within your Linux of
choice.  You need the usual suspects: a C compiler, binutils, make,
usbutils, git etc.  Once linux is installed and muforth has been
successfully compiled, it's time to set things up so muforth can
actually talk to tethered targets.

**Remember to copy the muforth udev rules to /etc/udev/rules.d/!!!**

### You Need usbipd

usbipd, which is 3rd party, is required to provide access to targets.

Open up powershell in administrator mode and execute the following:

```

prompt> winget install usbipd

```

Keep the admin terminal open, open up another terminal as a normal user.
We next need to fix linux so that it is aware of wsl so you won't need to run muforth as root.

Do the following:

```
$ sudo touch /etc/wsl.conf
$ sudo vi /etc/wsl.conf
```

Add the following to that file:

```
[boot]
systemd=true
```

Exit out of your linux session, but keep the user powershell terminal
open.

Switch to the admin terminal and execute the following:

```
 prompt> wsl --shutdown
 prompt> wsl (restarts wsl, launches into linux instance as user)
 user$ exit  (exit back to powershell admin mode)
```

While still in the admin terminal, plug a target into a free usb port; we use a Pico in this example 
[which has already had the muforth kernel uf2 flashed to it](https://muforth.nimblemachines.com/getting-started-with-the-raspberry-pi-pico/).

```
prompt> usbipd wsl list

BUSID   VID:PID    DEVICE
2-4     2e8a:0003  USB Mass Storage Device, RP2 Boot
blah
blah

prompt> usbipd wsl attach --busid 2-4
```

Groovy. Switch back to the user terminal:

```
$ ls -la /dev/ttyS3
```

This should show ttyS3 owned by root:dialout and rw for both. If you
type groups you'll see you're not part of group dialout, so fix that:

```
$ sudo addgroup $USER dialout
$ exit
user> bash (restart linux)
```

You should now be able to connect to your intended target.
