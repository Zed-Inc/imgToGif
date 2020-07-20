# Package

version       = "0.1.0"
author        = "Zed"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["imgToGif"]



# Dependencies

requires "nim >= 1.2.2",
         "https://github.com/rxi/gifwriter",
         "flippy == 0.4.5"