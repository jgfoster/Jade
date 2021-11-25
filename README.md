# Jade

This project is a rewrite of [Jade](https://github.com/jgfoster/Jade) using [Dart](https://dart.dev) and [Flutter](https://flutter.dev) to provide a [GemStone/S](https://gemtalksystems.com/products/gs64/) IDE available on the web.

## GciLibraryApp

The previous version of Jade (v2) included Windows 32-bit GCI libraries and could log in to most GemStone systems released over the past two decades. This made Jade a drop-in replacement for [Topaz](https://downloads.gemtalksystems.com/docs/GemStone64/3.6.x/GS64-Topaz-3.6/GS64-Topaz-3.6.htm) and [GBS](https://gemtalksystems.com/products/gbs-vw/) where no special setup was needed on the server (beyond NetLDI).

The approach taken here is different. We require the `GciLibraryApp` running on the server and listening on a well-known port (by default it is 50378 which is one beyond the typical 50377 used for NetLDI).

See docs/Server_setup.md for details on installing and running GciLibraryApp.

## JadeServer

All communication with GemStone is done through a `JadeServer` instance that provides an API for login/logout, abort/commit, execute, etc., and communicates using a WebSocket with the GciLibraryApp. Tests are in test/jade_server_test.dart and the functionality is tracked in docs/GCI_Function_Checklist.md. Much work could be done here.
