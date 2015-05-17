# image-slideshow

This Quartz Composition is continously scanning a folder of images and displays them. Usage scenarios include big screen slideshows (e.g. weddings) in which images are pushed via Wi-Fi SD-Cards to a central image folder.

Currently, the composition is scanning the directory for new images based on a pre-defined interval. However, it is planned to introduce a QCPlugin that uses FSEvent to subscribe to changes in a folder instead of scanning.
