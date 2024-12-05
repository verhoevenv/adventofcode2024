import std/sequtils
import std/sugar

# Package

version       = "0.1.0"
author        = "Vincent Verhoeven"
description   = "this is a description field I guess"
license       = "MIT"
bin           = (1..3).mapIt("day" & $it)
binDir        = "out"

# Dependencies

requires "nim >= 2.2.0"
requires "regex >= 0.25.0"