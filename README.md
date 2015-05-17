# image-slideshow

This Quartz Composition is continously scanning a folder of images and displays them. Usage scenarios include big screen slideshows (e.g. weddings) in which images are pushed via Wi-Fi SD-Cards to a central image folder.

The composition can be updated on a regular interval (e.g. 60 seconds), but primarly it is using a custom CQPlugin that employs the [FSEvents API](https://developer.apple.com/library/mac/documentation/Darwin/Reference/FSEvents_Ref/index.html) to subscribe to changes in a certain folder.