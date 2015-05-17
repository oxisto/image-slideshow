# image-slideshow

This Quartz Composition is observing a folder of images and displays them. Usage scenarios include big screen slideshows (e.g. weddings) in which images are pushed via Wi-Fi SD-Cards to a central image folder.

The composition uses a custom QCPlugin that employs the [FSEvents API](https://developer.apple.com/library/mac/documentation/Darwin/Reference/FSEvents_Ref/index.html) to subscribe to changes in a certain folder instead of continuously scanning the folder.

## Installation

First, build the custom QCPlugin. It should automatically be installed in `~/Library/Graphics/Quartz\ Composer\ Plug-Ins/` after running the the script from the command line.
```
cd FSWatcher
xcodebuild
```

Second, install the composition as a screen saver. Either by copying or linking the file to `~/Library/Screen Savers`.
