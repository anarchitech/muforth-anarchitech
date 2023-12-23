23 January 2023

muforth now has full support for the 8051, albeit *not* as a true 
Forth target, but rather as an "interactive assembly" target.

The 8051 architecture is suboptimal for implementing a true Forth
system, but it is an industry standard architecture that is widely used
and widely available (and has been for over 40 years.)

Compared to the commercially available GUI based IDE's for programming
the 8051, the user will find muforth to be a lean, work focused and
*fast* system for "on the fly" testing and programming of the 8051.

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

   $ git clone https://aur.archlinux.org/simplicitystudio5-bin.git
   $ cd simplicitystudio5-bin
   $ makepkg -si

After the install:

   $ sudo cp /opt/simplicitystudio5/developer/adapter_packs/ \
             usb/udev/*.rules /etc/udev/rules.d/
   $ sudo chmod 644 /etc/udev/rules.d/*silabs*

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

Hey, look at that, your board's headers are unpopulated. Break out your
soldering iron and at the very least, solder headers into p0.4, p0.5,
VDD and GND.

Wire up a PL2303 or similar. Connections as follows:

  3.3V -> Vdd
  GND  -> GND
  RXD  -> P0.4(UART TX)
  TXD  -> P0.5(UART RX)

On OpenBSD using the PL2303, ln -s /dev/cuaU0 serial-target in the
muforth/mu directory.

On Archlinux, the PL2303 *in this case* enumerates as /dev/ttyUSB0, so
that's your huckleberry for serial-target.

Reminder: regardless of OS choice, you'll need to find out who owns
serial-target.  For example, on OpenBSD /dev/cuaU0 is owned by
root and group dialer, so you'll need to run:

     doas usermod -G dialer yourUserName

Ok. Jack that sucker in. Crank up Iron Maiden.  You're just a teenage
dirtbag, baby.

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


