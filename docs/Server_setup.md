# Jade

This project is a rewrite of [Jade](https://github.com/jgfoster/Jade) using [Dart](https://dart.dev) and [Flutter](https://flutter.dev) to provide a [GemStone/S](https://gemtalksystems.com/products/gs64/) IDE available on the web.

## GciLibraryApp

The previous version of Jade (v2) included Windows 32-bit GCI libraries and could log in to most GemStone systems released over the past two decadees. This made Jade a drop-in replacement for [Topaz](https://downloads.gemtalksystems.com/docs/GemStone64/3.6.x/GS64-Topaz-3.6/GS64-Topaz-3.6.htm) and [GBS](https://gemtalksystems.com/products/gbs-vw/) where no special setup was needed on the server (beyond NetLDI). The approach taken here is to require the `GciLibraryApp` running on the server and listening on a well-known port (by default it is 50378 which is one beyond the typical 50377 used for NetLDI).

### Server Setup

#### WebGS

Jade v3 requires a web server running on GemStone. The web server for this application is a subclass of WebApp which is found in [WebGS](https://github.com/jgfoster/WebGS). Follow the install instructions there before proceeding.

#### Unicode Comparison Mode

Note that this application requires Unicode comparison and will configure the server to use this mode. Take care before using on an existing, legacy system!

#### Installation

Edit (or copy and edit to avoid Git conflicts) the `install.sh` bash script to reference the appropriate database and include the proper passwords.

## Tests

### Server Tests

The file `test/jade_server_test.dart` runs a suite of tests against the server (which is expected to be listening on localhost:50378).

### Debugging

While you typically run the server in a Topaz session using the `gemstone/install.sh` script, you have alternatives. One is to use Jade v2 running in Windows and connecting to the server. After the code is installed, stop the Topaz session (<ctrl>+<C>) and run `GsSocket closeAll. GciLibraryApp run: 50378.` in a Jade workspace (with whatever breakpoints you want). Check periodically to see if there are any background processes that didn't terminate (which could leave a stray login).

If you want to add logging, use `GsFile stdoutServer nextPutAll: 'DEBUG INFO HERE'; lf.` and then from a terminal on the server, use `tail -f gemnetobject_PID.log` to monitor the output.
