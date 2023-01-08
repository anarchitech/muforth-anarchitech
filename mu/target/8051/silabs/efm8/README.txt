#################################################
Sun Jan  8 08:32:56 PST 2023
OpenBSD 7.2 -current
dgs@deckard.localhost
#################################################

I have no idea how far this effort will get on the main repo, as there
are strong feelings about the venerable 8051's (un)suitability as forth
target.  However, some of us are using muforth in ways outside its
professed scope and generally ascribe to a philosophy of "pwn them all."

The intial target is the cheap and widely available Silicon Labs
EFM8BB1, available as of this writing as a little "starter kit" (Mouser
et. al.) for about US$6.25.

OOTB, this thing unfortunately comes with a preloaded program and *not*
the factory bootloader (hex file included in this directory.)  You need
to get rid of it, and I'm sorry to say that right now we don't have
a graceful way to do that with muforth and certainly not muforth running
on OpenBSD.

The *easiest and fastest* way to get rid of their crappy speed bump of a
demo and get the factory bootloader onto the chip which will allow you
to run the nascent serial-bootloader.mu4 program is to use Silicon Labs
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
select Browse and browse to the location of the hex file included in
this repo. Click erase in the Flash utility and then Program ... and it
should "just work."

Disconnect and close Simplicity Studio.  Don't uninstall it, we might
need it later. ;)

Hey, look at that, your board's headers are unpopulated. Break out your
soldering iron and at the very least, solder headers in the rows on the
sides of the board.

Wire up a PL2303 or similar. Connections as follows:

  3.3V -> Vdd
  GND  -> GND
  RXD  -> P0.4(UART TX)
  TXD  -> P0.5(UART RX)

Jumper the board between P2.0 and another GND (need to drive this low).

On OpenBSD using the PL2303, ln -s /dev/cuaU0 serial-target in the
muforth/mu directory.

On Archlinux, the PL2303 *in this case* enumerates as /dev/ttyUSB0, so
that's your huckleberry for serial-target.

   $ cd muforth/mu
   $ ./muforth -f target/8051/silabs/efm8/all/serial-bootloader.mu4

and

   (( EFM8 serial bootloader 
   (( Target endianness ))
   (( CRC-16-CCITT ))
   (( Serial expect/send ))))
   spy on  Ok (hex)
   hi >ff 
   >24 >03 >30 >30 >01 <40  Ok (hex)

Congrats, you're there.

== UPDATE ==

Two new words have been added, erase-reset-vector and test-crc.

Both "work" ... although test-crc throws a 43h back indicating that
there's something up with the either the CRC algorithm used (scraped
from the MSP430) or something ...

The upshot after running both of these is that you will no longer need 
to drive P2.0 low by jumpering between it and GND, so there's that.
