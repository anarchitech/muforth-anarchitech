# Running muforth on Windows 11 via WSL2 

muforth will run on Windows 11 via wsl2 without too much effort if your
PC supports the hypervisor.  How to configure your machine, setup wsl2
to work with the hypervisor and install one of the linux options is
outside the scope of this document.  There's a kiloton of info out there
on the interwebs for you to wade through regarding how to do this. Enjoy.

Likewise, so is setting up your dev environment within your Linux of
choice.  You need the usual suspects: a C compiler, binutils, make,
usbutils, git etc.  Once linux is installed and muforth has been
successfully compiled, it's time to set things up so muforth can
actually talk to tethered targets.


### Surprise Fuckers! y0u n33d a 3rd party tool!

usbipd-win is required to provide access to targets. Period.  It's
distributed through the Microsoft store, and their version is (we guess)
aimed at the github version.  This is the fastest, easiest way to get
it and the tracking and privacy violations are free. Exciting stuff.

Open up powershell in administrator mode and execute the following:

```

prompt> winget install usbipd

```

Keep the admin terminal open, open up another terminal as a normal user.
We next need to fix linux so that it is aware of wsl so you won't need to run muforth as root.

Do the following:

```
user> bash (start linux)
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
Groovy. Switch back to the user terminal and fire up linux:
```
you@blackhouse:~$ lsusb
...
Bus 001 Device 004:  ID 2e8a:003 Raspberry Pi RP2 Boot Putin
...
```

You should now be able to connect to your intended target.

### My dudes, do I have to do this every time???

No.  Well, yes.  Kind of?  Look, wtf do you want. It's fucking
Microsoft.

As near as we can tell, once you've set this all up, you don't need to
fiddle with the powershell terminal in admin mode.  But you DO need to
open up two instances of the powershell terminal. So, here's a nice
procedure in list form, because lists.

1) Open up a powershell terminal and open up yet another instance (you can
just open it as a tab.  Yay, gui.)

2) In one, type bash and launch your Linux
```
C:\Users\youbaby> bash
```

3) In the other, type the following:
```
C:\Users\yeahyougirl> usbipd wsl list
BUSID   VID:PID     DEVICE              STATE
2-4     2e8a:0003   USB Mass Carnage    Not attached
blah    blah        blah                blah

C:\Users\whynotthefrench> usbipd wsl attach --busid 2-4
```
4) Back to the first terminal where your Linux monkey is running:
```
you@winightmare:~$ lsusb
...
Bus 001 Device 004:  ID 2e8a:003 Raspberry Pi RP2 Boot Putin
...
```
5) And then fire up muforth
```
$ cd muforth/mu
$ ./muforth -f target/ARM/board/raspberry-pi-pico.mu4
...
```

### That takes too long.  I just want to connect.

Ha ha ha. No. You can't. Here's what happens if you plug a target in and
just try to attach the damn thing:

```
C:\Users\POC||GTFO> usbipd wsl attach --busid 2-4
usbipd: error: The selected WSL distribution is not running; keep a
command prompt to the distribution open to leave it running.
```
Mmmmkay?
