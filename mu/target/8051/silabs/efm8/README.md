## 23 January 2023

muforth now includes full support for the 8051, albeit *not* as a true 
Forth target, but rather as an "interactive assembly" target.

The 8051 architecture is suboptimal for implementing a true Forth
system, but it is an industry standard architecture that is widely used
and widely available (and has been for over 40 years.)

Compared to the commercially available GUI based IDE's for programming
the 8051, the user will find muforth to be a lean, work focused and
*fast* system for "on the fly" testing and programming of the 8051.

---

## Bootstrapping

The intial target is the cheap and widely available Silicon Labs
EFM8BB1, available as of this writing as a little "starter kit" (Mouser
et. al.) for about US$6.25.

OOTB, this kit unfortunately comes with a preloaded program and *not*
the factory bootloader (which we have made available in this directory.)  
You need to get rid of it, and I'm sorry to say that right now we don't have
a graceful way to do that with muforth for this particular kit.

The *easiest and fastest* way to get rid of their crappy speed bump of a
demo and get *our* working chat code onto the chip is to use Silicon Labs
Simplicity Studio v5.  As far as vendor IDE's go, it's not the most
offensive, but you'll either need a Windows box, an Ubuntu box ... or
you can avoid either of those things and use Archlinux.

The AUR has copy of Simplicity Studio v5 that "just worked" for us with
zero fiddling:

   https://aur.archlinux.org/simplicitystudio5-bin.git

On Archlinux:

```

   $ git clone https://aur.archlinux.org/simplicitystudio5-bin.git
   $ cd simplicitystudio5-bin
   $ makepkg -si

```
After the install:

```
   $ sudo cp /opt/simplicitystudio5/developer/adapter_packs/ \
             usb/udev/*.rules /etc/udev/rules.d/
   $ sudo chmod 644 /etc/udev/rules.d/*silabs*
```

Yes, for some reason (?!) the udev rules were installed as executables.

Start Simplicity Studio and wade through the initialization and restart.
It's fairly painless, but be warned, this is quiche-eater bloatware so
if you're using something with a small drive (like an old Acer14
chromebook running coreboot and Archlinux with a soldered in 32gb flash
drive) ... watch your disk space. ;)

Once it restarts, connect the board and you should see it enumerate in
the upper left under Debug Adapters and the top middle under Connected
Devices.  It will prompt you to install their recommended toolkit for
wrangling their chip.  Do it.

After that's finished, click on the device in the Debug Adapters tile,
click on Tools in the Toolbar menu, select the Flash utility, and then
select Browse and browse to the location of the chat.hex file included in
this directory. Click erase in the Flash utility and then Program ... and 
it should "just work."

Disconnect and close Simplicity Studio.  Don't uninstall it, we might
need it later if you bork the bootloader code. ;)

---

## Soldering & serial adaptor

Hey, look at that, your board's headers are unpopulated. Break out your
soldering iron and at the very least, solder headers into p0.4, p0.5,
VDD and GND.

Wire up a PL2303 or similar. Connections as follows:
```
  3.3V -> Vdd
  GND  -> GND
  RXD  -> P0.4(UART TX)
  TXD  -> P0.5(UART RX)
```
---

## Device enumeration

On OpenBSD using the PL2303, ln -s /dev/cuaU0 serial-target in the
muforth/mu directory.

On Archlinux, the PL2303 *in this case* enumerates as /dev/ttyUSB0, so
that's your huckleberry for serial-target.

Reminder: regardless of OS choice, you'll need to find out who owns
serial-target.  For example, on OpenBSD /dev/cuaU0 is owned by
root and group dialer, so you'll need to run
```
  doas usermod -G dialer yourUserName
```

---

## Initiating chat with the target

Ok. Jack that sucker in. Crank up Iron Maiden.  You're just a teenage
dirtbag, baby.

muforth is a tethered host to target system. You work with the chip in
real time, on the fly.

```
$ cd muforth/mu
$ ./muforth -f target/8051/board/efm8bb1lck.mu4
muforth/64 (60ea7b8f) 2023-jan-20 16:33 (https://muforth.nimblemachines.com/)
Copyright (c) 2002-2023 David Frech (read the LICENSE for details)

Type 'settings' to see a few of muforth's tweakable behaviours.

(( Silabs EFM8BB1LCK board 
(( EFM8BB10F8 chip 
(( EFM8BB1 equates )) 
(( Target endianness )) 
(( Serial expect/send )) 
(( Core target compiler (chains and token consumers) )) 
(( 8051 memory image )) 
(( 8051 assembler )) 
(( 8051 disassembler )) 
(( 8051 target compiler )) 
(( 8051 interaction .h8 again.  dumps again.  )) 
(( Intel hex file support (reading and writing) )) 
(( Core flash programming )) 
(( 8051 chat (host) 4# again.  )) 
(( EFM8 serial bootloader 
(( CRC-16 CCITT )) >b again.  b> again.  >w again.  >cmd again.  )) )) )) 
chat
Chat firmware version 60ea7b8f
CA-RRV-P  R0 R1 R2 R3  R4 R5 R6 R7    RP   PC
00000000  5e 5e f2 00  99 a3 00 c4  00c5 1e8a Ok (chatting) (hex) (flash)
```

Ok, let's dissect this a bit.  The last 4 lines are where the interact
code starts.

```
chat <--- muforth word typed at command line to start host->target
          interaction.

Chat firmware version 60ea7b8f <--- current firmware version

CA-RRV-P  R0 R1 R2 R3  R4 R5 R6 R7    RP   PC
00000000  5e 5e f2 00  99 a3 00 c4  00c5 1e8a Ok (chatting) (hex) (flash)
^      ^  ^                     ^   ^    ^
|______|  |_____________________|   |    |__ Program counter
 Flags     Registers R0-R7          |_______ Return pointer
 ```
R0-R7 are *stored* in bytes 0-7 of *ram* and are a copy of register R0-R7 on
the target.

## Basics (WIP)

We can read and write from/to ram, xram and flashram.
```
0 du ram
0000  5e 5e f2 00  99 a3 00 c4  00 c8 7a 11  12 24 00 00
      ^                     ^
      |_____________________|
        Matches R0 - R7 
```
At any time we can compare what's on the host in flash/ram/xram by
typing x after typing 0 ram/flash/xram du <enter>

```
0 du ram
0000  5e 5e f2 00  99 a3 00 c4  00 c8 7a 11  12 24 00 00 (x typed here)
0000  ff ff ff ff  ff ff ff ff  ff ff ff ff  ff ff ff ff <--- host 
      5e 5e f2 00  99 a3 00 c4  00 c8 7a 11  12 24 00 00 <--- target
```

Let's navigate to the area in flash where the bootloader is stored:
```
flash  Ok (chatting) (hex) (flash)
^      ^                         ^
|      |_________________________|
cmd         Response
```
```
1e00 du 
1e00  c1 8c 60 ea  7b 8f 30 98  fd c2 98 af  99 22 30 99 
1e10  fd c2 99 8f  99 22 d1 06  ae 1f c1 06  a3 ff c1 0e 
1e20  df 04 90 1e  02 22 df 07  d1 16 8e 83  8f 82 22 df ...
```

Nifty, we're looking at bytes. This is where chat.hex was stored.

The first 4 lines of chat.hex for comparison:

```
:020000040000FA
:101E0000C18C60EA7B8F3098FDC298AF99223099DF
:101E1000FDC2998F9922D106AE1FC106A3FFC10E44
:101E2000DF04901E0222DF07D1168E838F8222DF0D
```

Carefully tease them apart and you'll see where they match.

Ok, from 1e20 above, let's try disassembling the actual code.
While still in du, type the letter i:

```
1e20  df 04 90 1e  02 22 df 07  d1 16 8e 83  8f 82 22 df <- i typed here 
1e20  df 04     djnz r7 1e26   <- Disassembly starts here.
1e22  90 1e 02  mov dptr #1e02 
1e25  22        ret 
1e26  df 07     djnz r7 1e2f 
1e28  d1 16     acall 1e16 
1e2a  8e 83     mov DPH r6 
1e2c  8f 82     mov DPL r7 
1e2e  22        ret 
1e2f  df 07     djnz r7 1e38 
```
