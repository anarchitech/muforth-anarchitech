
# What is muforth?

muforth is a small, simple, fast, indirect-threaded code (ITC) Forth intended
for use as a cross-compiler for microcontrollers and other embedded devices.
It is written in C and its core is very portable. Because of its Forth nature,
it is naturally extensible, scriptable, and customizable.

It is very well-suited to interactive coding, debugging, and exploration, and
is a great tool for bringing up new hardware.

It has support – in varying degrees of completeness – for a number of
different architectures and chip families.

##  Under active development

  * [8051](mu/target/8051)
  * [ARMv6-m](mu/target/ARM/v6-m) (aka Cortex-M0/M0+)
  * [ARMv7-m](mu/target/ARM/v7-m) (aka Cortex-M3/M4)
  * [MSP430](mu/target/MSP430) (TI)
  * [RISC-V](mu/target/RISC-V) (initially, the SiFive FE310 and GigaDevice
    GD32VF103)

## Dormant, or less actively developed

  * [ARMv5](mu/target/ARM/v5) (originally targeting an ARM AEB-1 board running an ARM7DI processor)
  * [AVR](mu/target/AVR) (Atmel)
  * [HC08 and HCS08](mu/target/HC08) (Motorola/Freescale/NXP)
  * [PIC18](mu/target/PIC18) (Microchip)


# Why yet another Forth?

I initially wrote muforth because I wanted to try out some implementation
ideas. The core language primitives are written in C, but initially muforth
compiled Forth words via a simple native code compiler for the x86. I quickly
realized that simplicity and portability were more important than speed. The
current implementation is a straightforward indirect-threaded Forth - and it
is _quite_ fast!

Its implementation is no longer the point. Its sole reason for existing is to
be a cross-compiler for _other_ Forths, and their implementations are in no
way tied to muforth’s.

By keeping it small and simple, it is much more likely to be a useful tool
that people can customize.

It’s [BSD licensed](LICENSE), so do what you want with it! I’d love to hear
about innovative or unusual uses of muforth.


# Starting points

[BUILDING](BUILDING) will tell you how to build muforth. It’s stupid simple.

Look in [mu/target/](mu/target) to find a target that interests you. There is
generally a `mu/target/<target-name>/build.mu4` that loads the cross-build
environment. Use it as an “index” to find the assembler, disassembler,
meta-compiler, kernel, and other key pieces of code.


# Documentation

Sadly, there isn’t a lot of documentation right now. A good place to start is
to read the source.

The code – both the C code that implements the Forth virtual machine and the
muforth code that does everything else – is carefully and in some cases
extensively (even obsessively!) commented. Right now your best source of
documentation is the code! Luckily for you, there isn’t that much of it, so
reading it is actually possible. That’s part of the point of muforth; I want
it to be a [convivial tool](https://www.nimblemachines.com/convivial-tool/).

The heart of the system is the Forth code that muforth reads when it first
starts: [mu/startup.mu4](mu/startup.mu4). You’ll learn a lot by reading this!

[muforth.nimblemachines.com](https://muforth.nimblemachines.com/) is also,
finally, spreading its wings.


# Talks

In March 2008 I gave a [talk](https://vimeo.com/859408) about bootstrapping,
muforth, and [convivial tools](https://www.nimblemachines.com/convivial-tool/).

Warning: I wave my arms around a lot, and the audio and video quality isn’t
that great, but you might find it interesting, or at least amusing.

It’s also hard to see my slides. If you want to “follow along”, [download my
slides](talks/2008-mar-30-PNCA), and use `less` to view them – ideally in a
text window that is at least 30 lines high – like so:

```
less -30 ~/muforth/talks/2008-mar-30-PNCA
```

[![March 2008 talk on Vimeo](https://user-images.githubusercontent.com/3320/214488827-47171f1b-5221-44d0-b9d9-7febcff83628.png)](https://vimeo.com/859408)

# Above all, enjoy!
