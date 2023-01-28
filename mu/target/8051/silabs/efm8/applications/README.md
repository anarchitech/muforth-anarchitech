This directory contains sample applications for the Silicon Labs Busy
Bee EFM8BB1LCK dev kit. Currently there is one.

## sfrprobe-efm8bb1.mu4 

This is a simple and moderately useful demo application which can be loaded and
flashed onto the target to provide a UI for grabbing values from the current 
state of all SFR's. Obviously you can extend or modify this to get or set other
registers etc.  You can split this file up into its individual sections if you
are only working with particular areas of the target (just make sure when you
split it up to do so correctly:

```
     -- Section title
     __meta
     hex
     
     label defs
     
     any forth definitions
     
     __meta
     hex
```

The layout of the code matches the reference manual documentation, efm8bb1-rm.pdf

Here are some file stats:

```
sfrprobe-efm8bb1.mu4: 677 LOC
                      35253 Bytes file size
                      341 Bytes compiled on target
```

Obviously, there is considerable space left on the target; 7,339 bytes
worth.  We hit the bootloader at 0x1e00 and the target compiled version of 
sfrprobe-efm8bb1.mu3 occupies 0x0000 - 0x0155 in flash. 

Note that only the label (assembler) definitions are compiled onto the target
as bytecode.  This is why the compiled code on the target is so small.

Remember, our goal here was *not* to get a forth kernel/system onto the 8051; 
it's a lousy target for that.  But it *is*, like HCS08, a fine target for an 
*interactive assembler*. daf has strived to keep the mnemonics true to the 
MCS-51 instruction set and (and the EFM8BB1 extensions,) but as this *is* a 
forth based system, remember you're in RPN mode.  Take a look at the code for 
examples.

Everything else is held on the host side and simply provides the UI and
formats the data.  You don't *need* to run use this example, but it might help 
while you get your head around the architecture. We use a version of it flashed
to the target to aid in interactive development (and we also just write and
flash test words on the fly.)  Forth is highly extensible and you'll figure out
a workflow that is best for you.

### Some useage examples:

Load the file as follows:

```
$ cd muforth/mu
$ ./muforth -f target/8051/board/efm8bb1lck.mu4 \ 
            -f target/8051/silabs/efm8/applications/sfrprobe-efm8bb1.mu4
muforth/64 (b751afbc) 2023-jan-26 17:35
(https://muforth.nimblemachines.com/)
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
(( CRC-16 CCITT )) >b again.  b> again.  >w again.  >cmd again.  )) ))
)) 
chat 
Chat firmware version de73f1b6
CA-RRV-P  R0 R1 R2 R3  R4 R5 R6 R7    RP   PC
00000000  16 8a fb 73  3b 1a 80 02  00c5 1e8a Ok (chatting) (hex)
(flash)
```

Executing the word 'help'

```
help
Currently available help words for sfrprobe. 'command' and 
'subcommand' refer to forth words executed on the host. In most 
cases help words closely resemble the forth word that executes 
on the host and fetches SFR values from the target. Help words are 
of the form 'word?'. Page numbers refer to the EFM8 Busy Bee Family 
Reference Manual, efm8bb1-rm.pdf 

 * flashcon?   -- Flash Memory/Control                     pg  30 
 * devinfo?    -- Device Identification                    pg  38 
 * interrupts? -- Interrupts                               pg  40 
 * pwr?        -- Power Management and Internal Regulators pg  50 
 * clockosc?   -- Clocking and Oscillators                 pg  54 
 * rssmc?      -- Reset Sources and Power Supply Monitor   pg  59 
 * core?       -- CIP-51 Microcontroller Core              pg  66 
 * ports?      -- Port I/O, Xbar, Xtrnl Ints, & Port Match pg  75 
 * adc?        -- Analog-to-Digital Converter (ADC0)       pg 103 
 * cmp?        -- Comparators (CMP0 and CMP1)              pg 127 
 * crc?        -- Cyclic Redundancy Check (CRC0)           pg 138 
 * pca?        -- Programmable Counter Array (PCA0)        pg 145 
 * spi?        -- Serial Peripheral Interface (SPI0)       pg 170 
 * smb?        -- System Management Bus / I2C (SMB0)       pg 183 
 * timers?     -- Timers (0,1,2,3)                         pg 204 
 * uart0?       -- Universal Asynchronous Rx/Tx (UART0)    pg 226 
 * wdtcn?      -- Watchdog Timer (WDT0)                    pg 231 

Any subcommands for the above words are shown in their output. 

 Ok (chatting) (hex) (flash)
```

Executing the help command adc?

```
adc?
Currently available command(s) include: 

 * adccon@   -- Fetch ADC0 Control 0/1, Configuration, Accumulator
                Config, Power Control, Burst Mode Tracking Time and 
                Multiplexer Select values. 
 * adcbytes@ -- Fetch ADC0 Data Word and Byte values 
 * vrefctrl@ -- Fetch Voltage Reference Control values. 

Subcommands for the above shown in output display. 

 Ok (chatting) (hex) (flash)
```

Executing adccon@

```
A-RRV-P  R0 R1 R2 R3  R4 R5 R6 R7    RP   PC
00000000  00 00 f8 00  0f 1e 1f 02  00c5 1e8a
          ^^ ^^ ^^ ^^  ^^ ^^ ^^ 
ADC0CN0 __|  |  |  |   |  |  |      ADC0 Control 0        -- 'adc0cn0@ rx r0 c@' 
ADC0CN1 _____|  |  |   |  |  |      ADC0 Control 1        -- 'adc0cn1@ rx r1 c@' 
ADC0CF  ________|  |   |  |  |      ADC0 Configuration    -- 'adc0cf@  rx r2 c@' 
ADC0AC  ___________|   |  |  |      ADC0 Accumulator Conf -- 'adc0ac@  rx r3 c@' 
ADC0PWR _______________|  |  |      ADC0 Power Control    -- 'adc0pwr@ rx r4 c@' 
ADC0TK  __________________|  |      ADC0 BurstMd TrckTm   -- 'adc0tk@  rx r5 c@' 
ADC0MX  _____________________|      ADC0 Multiplexer Sel. -- 'adc0mx@  rx r6 c@' 

 Ok (chatting) (hex) (flash)
```

There you have it.  Use, don't use, extend, ruthlessly pare ... it's your sandbox. 
