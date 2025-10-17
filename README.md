# libdsmcc

Library and tools for the decoding of DSM-CC used to transmit data within a MPEG-2 stream, used for extracting MHEG-5/MHP files from digital television (DVB).

Version: 0.7.1 (unofficial fork)

## About

This version of the fork contains modifications to support Microsoft Windows via MinGW (specifically tested with mxe). It should also still work on Linux.

By default files are saved in the Windows temporary directory `%TEMP%\cache`, or `/tmp/cache` on Linux. You can set the destination cache directory in the dsmcc_status() function. Set the "tmp" variable accordingly, or to NULL for the defaults.

## Building

This project uses a simple Makefile. Customise the CC, LD etc variables to match your toolchain, then run the `make` command.

## Version History

| Version                  | Author           | URL                                       |
|-----------------------------------------------------------------------------------------|
| **Original version by:** | Richard Palmer   | https://sourceforge.net/projects/libdsmcc |
| **0.7.0 fork by:**       | Andrey Pridvorov | https://github.com/ua0lnj/libdsmcc        |
| **0.7.1 fork by:**       | Andrew Nile      | https://github.com/AndrewNile/libdsmcc    |