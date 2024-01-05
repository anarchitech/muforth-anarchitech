This is for the Arduino.

1) If you're just banging at the Arduino via the U16/USB tether,
comment out the -d disco in build.mu4

2) Make sure that's uncommented if you're using an F303 as an ICSP

3) If you're using the F303 to poke at an Arduino *board* via ICSP,
then make sure you uncomment the 3 clock lines in 
target/AVR/load-chat-serial.mu4 (see the code comment!)

4) Edit target/AVR/load-stm32-discovery.mu4) and uncomment which
flavor of STM32 board you're using IF you are going at this thing
via ICSP.  Currently the two supported boards are the F072 and the F303.

5) IF you are running OpenBSD you'll need to figure out what your
STM32x enumerates as and *chown or chmod* that device accordingly.

6) IF you are running OpenBSD you'll need to likely need to edit
target/ARM/debug/stlink-v2.mu4  on line 44 and point it at your
actual /dev/ugenX device.  JUST AS AN EXAMPLE on a Thinkpad X1 Carbon
running OpenBSD 7.4 -current that looks like this:

---------- snip ----------------

43 .ifdef stlink-v2-1
44    z" /dev/ugen3.01" open-file-rw  dup constant stlink-read
45                                        constant stlink-write
 
---------- snip ----------------
