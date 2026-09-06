Jade
====

Jade is an Alternative Development Environment (IDE) for GemStone/S that runs on Microsoft Windows. This [screencast](https://www.youtube.com/watch?v=dnRB5rBbkiI) gives a brief demo from 2013. Jade is built in (and inspired by) Dolphin Smalltalk from [Object-Arts](https://github.com/dolphinsmalltalk/Dolphin).

### Runtime Installation
The [Releases](https://github.com/jgfoster/Jade/releases) page contains links to a zip file with the executable and supporting libraries.

### Development Installation

* Clone [Dolphin](https://github.com/dolphinsmalltalk/Dolphin)
  * Checkout `origin/release/7.2`
  * Run `FetchVM.cmd`
* Clone [Jade](https://github.com/jgfoster/jade) into the Dolphin directory
  * Run `Jade\BootDPRO.cmd` and close Dolphin
  * Run `Jade\BootJade.cmd`
  * Make edits to the code (and save packages)
  * In the System Browser, select the “Jade Deployment” package
  * From the context (right-click) menu, select “Deployment” then “Deploy Executable…"
  * From the Lagoon Deployment Wizard, click the Deploy button