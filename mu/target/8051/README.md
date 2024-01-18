# muforth 8051 support

This is a WIP, initially targeting the Silicon Labs devices.

Development on this has been *fast*.  The 8051 is not an ideal
target for Forth, but muforth's usefulness extends beyond simply
creating Forth based systems on microcontroller targets.

For a quickstart on how to get this to work, [see this.](https://github.com/anarchitech/muforth-anarchitech/blob/master/mu/target/8051/silabs/efm8/README.md)

# UPDATE: 18 Jan 2024

For OpenBSD 7.4 -current there appears to be a fly in the ointment; 
the BB1 no longer enumerates as serial device accessible via /dev/cuaUx, 
but instead is enumerating strictly as a uhid device.

Note that this applies to accessing the device via usb; UART chatting is
still available via P.4/.5 (tx,rx)

Somebody will dig into this RSN.
